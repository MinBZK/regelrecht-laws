#!/usr/bin/env python3

import json
import sys
from pathlib import Path
from pprint import pprint
from typing import Dict, List, Set, Tuple

import jsonschema
import yaml
from jsonschema import validate


def load_yaml(file_path: Path) -> dict:
    """Load and parse a YAML file."""
    with open(file_path) as yf:
        data = yaml.safe_load(yf)
        # Convert to JSON and back to ensure we have JSON-compatible structures
        return json.loads(json.dumps(data, default=str))


def validate_schema(schema_file: Path, yaml_file: Path) -> None:
    """Validate a YAML file against the JSON schema."""
    with open(schema_file) as sf:
        schema = json.load(sf)

    data = load_yaml(yaml_file)

    try:
        validate(instance=data, schema=schema)
        print(f"Schema validation of '{yaml_file}' against '{schema_file}' successful.")
    except jsonschema.exceptions.ValidationError as err:
        print(f"Schema validation error in '{yaml_file}' against '{schema_file}': {err.message}")
        sys.exit(1)


def collect_service_references(data: dict) -> Set[Tuple[str, str, str]]:
    """Collect all service references from inputs."""
    references = set()

    # Process input fields
    input_fields = data.get("properties", {}).get("input", [])
    for field in input_fields:
        service_ref = field.get("service_reference")
        if service_ref:
            references.add((service_ref["service"], service_ref["law"], service_ref["field"]))

    return references


def collect_service_outputs(data: dict) -> Set[Tuple[str, str, str]]:
    """Collect all output fields that could be referenced."""
    outputs = set()

    # Get the service and law from the file metadata
    service = data.get("service")
    law = data.get("law")
    if not service or not law:
        return outputs

    # Process output fields
    output_fields = data.get("properties", {}).get("output", [])
    for field in output_fields:
        outputs.add((service, law, field["name"]))

    return outputs


def validate_service_references(yaml_files: List[Path]) -> None:
    """Validate that all service references have corresponding outputs."""
    all_references = set()
    all_outputs = set()
    references_by_file: Dict[Path, Set[Tuple[str, str, str]]] = {}

    # Collect all references and outputs
    for file_path in yaml_files:
        data = load_yaml(file_path)

        # Collect references from this file
        references = collect_service_references(data)
        all_references.update(references)
        references_by_file[file_path] = references

        # Collect outputs from this file
        outputs = collect_service_outputs(data)
        all_outputs.update(outputs)

    # Check for missing references
    missing_references = all_references - all_outputs
    if missing_references:
        print("\nMissing service reference outputs:")
        for service, law, field in sorted(missing_references):
            print(f"  - {service}.{field} (law: {law})")
            # Find which files reference this missing output
            for file_path, refs in references_by_file.items():
                if (service, law, field) in refs:
                    print(f"    Referenced in: {file_path}")
        sys.exit(1)
    else:
        print("\nAll service references have corresponding outputs.")


def collect_defined_variables(data: dict) -> Set[str]:
    """Collect all defined variables from inputs, sources, definitions, and parameters."""
    variables = set()

    properties = data.get("properties", {})

    # Add parameters
    for param in properties.get("parameters", []):
        variables.add(param["name"])

    # Add inputs
    for inp in properties.get("input", []):
        variables.add(inp["name"])

    # Add sources
    for source in properties.get("sources", []):
        variables.add(source["name"])

    # Add definitions
    for def_name in properties.get("definitions", {}).keys():
        variables.add(def_name)

    return variables


def find_variables_in_string(s: str) -> Set[str]:
    """Find all $VARIABLE references in a string."""
    if not isinstance(s, str):
        return set()
    return {word for word in s.split() if word.startswith("$") and word.isupper()}


def find_variables_in_dict(d: dict) -> Set[str]:
    """Recursively find all $VARIABLE references in a dictionary."""
    variables = set()
    for value in d.values():
        if isinstance(value, dict):
            variables.update(find_variables_in_dict(value))
        elif isinstance(value, list):
            for item in value:
                if isinstance(item, dict):
                    variables.update(find_variables_in_dict(item))
                else:
                    variables.update(find_variables_in_string(str(item)))
        else:
            variables.update(find_variables_in_string(str(value)))
    return variables


def validate_variable_definitions(yaml_files: List[Path]) -> None:
    """Validate that all $VARIABLES are defined."""

    error = False
    for file_path in yaml_files:
        data = load_yaml(file_path)

        defined = collect_defined_variables(data)
        referenced = find_variables_in_dict(data)

        # calculation_date is implicitly defined
        referenced.discard("$calculation_date")

        undefined = {v.replace("$", "") for v in referenced} - defined

        if undefined:
            print(f"\nUndefined variables in {file_path}:")
            for var in sorted(undefined):
                print(f"  - {var}")
            error = True
    if error:
        sys.exit(1)

    print("\nAll variables are properly defined.")


def main():
    BASE_DIR = Path("laws")
    schema = "schema/v0.1.6/schema.json"

    # Find all YAML files
    yaml_files = list(BASE_DIR.rglob("*.yaml")) + list(BASE_DIR.rglob("*.yml"))

    # First validate all files against the schema
    for f in yaml_files:
        validate_schema(schema, f)

    # Then validate service references
    validate_service_references(yaml_files)
    validate_variable_definitions(yaml_files)


if __name__ == "__main__":
    main()

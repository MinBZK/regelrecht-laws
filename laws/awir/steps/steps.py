# Import all steps from the main features/steps directory
import sys
from pathlib import Path

# Add the project root to path so we can import from features.steps
project_root = Path(__file__).parent.parent.parent.parent
sys.path.insert(0, str(project_root))

from features.steps.steps import *

# Import environment hooks from the main features directory
import sys
from pathlib import Path

# Add the project root to path so we can import from features
project_root = Path(__file__).parent.parent.parent
sys.path.insert(0, str(project_root))

from features.environment import *

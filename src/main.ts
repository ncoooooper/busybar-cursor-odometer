import {marks} from "./front";
import {instrument} from "@shared/instrument";

instrument({
  marks,
  "title": "CURSOR ODOMETER",
  "primary": "Cursor Odometer",
  "accent": "#57BFAA",
  "cadence": 2200,
  "motion": {enabled:false},
  "setup": "Start companion/serve.py"
});

#|
// default imports
import foo from "foo";
import {default as foo} from "foo";

// named imports
import {} from "foo";
import {bar} from "foo";
import {bar, baz} from "foo";
import {bar as baz} from "foo";
import {bar as baz, xyz} from "foo";

// glob imports
import * as foo from "foo";

// mixing imports
import foo, {baz as xyz} from "foo";
import foo, * as bar from "foo";

// just import
import "foo";
|#

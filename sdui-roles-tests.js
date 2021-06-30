// Import Tinytest from the tinytest Meteor package.
import { Tinytest } from "meteor/tinytest";

// Import and rename a variable exported by sdui-roles.js.
import { name as packageName } from "meteor/sdui-roles";

// Write your tests here!
// Here is an example.
Tinytest.add('sdui-roles - example', function (test) {
  test.equal(packageName, "sdui-roles");
});

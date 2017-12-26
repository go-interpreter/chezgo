var math = require("mathjs");
var a = math.matrix([[7, 1], [-2, 3]]);
var d = math.matrix([[7, 1], [-2, 3]]); 

var t0 = new Date().getTime();

math.multiply(a, d);      

var t1 = new Date().getTime();

console.log("matrix multiply in javascript took " + (t1 - t0) + " milliseconds.")

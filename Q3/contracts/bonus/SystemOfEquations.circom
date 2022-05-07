pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
// include ""; // hint: you can use more than one templates in circomlib-matrix to help you
include "../../node_modules/circomlib-matrix/circuits/matScalarMul.circom";


template SystemOfEquations(n) { // n is the number of variables in the system of equations
    signal input x[n]; // this is the solution to the system of equations
    signal input A[n][n]; // this is the coefficient matrix
    signal input b[n]; // this are the constants in the system of equations
    signal output out; // 1 for correct solution, 0 for incorrect solution
    signal sum[n][n];
    signal sumRow[n];


    // for (var i=0; i < n; i++) {
    // //EACH ROW
    // // matScalarMul(n, 1);
    // // scalar mult x[i] * A[i][]
    // }

    // add each new array to a scalar
    // matElemSum(n, 1)
    var idx = 0;
    // var sumRow = 0;
    // [bonus] insert your code here
    for (var i=0; i < n; i++) {
        sum[i][0] <== x[0] * A[i][0];
        for (var j=1; j < n; j++) {
            sum[i][j] <== x[j] * A[i][j] + sum[i][j-1];
            idx++;
        }
        if(i > 0){
            sumRow[i] <== sumRow[i-1] + sum[i][n-1] - b[i];
        }else{
            sumRow[i] <== sum[i][n-1] - b[i];
        }
    }

    component isZero = IsZero();
    isZero.in <== sumRow[n-1];
    out <== isZero.out;//sumRow[n-1];
}

component main {public [A, b]} = SystemOfEquations(3);
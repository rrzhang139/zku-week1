#!/bin/bash

cd contracts/bonus
ls
mkdir SystemOfEquations

if [ -f ./powersOfTau28_hez_final_10.ptau ]; then
    echo "powersOfTau28_hez_final_10.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_10.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau
fi

echo "Compiling SystemOfEquations.circom..."

# compile circuit

circom SystemOfEquations.circom --r1cs --wasm --sym -o SystemOfEquations

# generate witness

cd SystemOfEquations/SystemOfEquations_js

node generate_witness.js SystemOfEquations.wasm ../../input.json witness.wtns

cd ../..

# Start a new zkey and make a contribution

snarkjs groth16 setup SystemOfEquations/SystemOfEquations.r1cs powersOfTau28_hez_final_10.ptau SystemOfEquations/circuit_0000.zkey
snarkjs zkey contribute SystemOfEquations/circuit_0000.zkey SystemOfEquations/circuit_final.zkey --name="1st Contributor Name" -v -e="random text"
snarkjs zkey export verificationkey SystemOfEquations/circuit_final.zkey SystemOfEquations/verification_key.json

# generate proof

echo "Generating Proof...."

snarkjs groth16 prove SystemOfEquations/circuit_final.zkey SystemOfEquations/SystemOfEquations_js/witness.wtns SystemOfEquations/proof.json SystemOfEquations/public.json


cd ../..
#!/bin/bash

# Step 1: Install Node:
# Go to: https://nodejs.org/en/download/package-manager/

# Step 2: Install serverless
npm install -g serverless

# Step 3: Setup serverless
serverless config credentials --provider aws --key AKIAVHTHTMAOXSYUNOPR --secret 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 --profile serverless-admin

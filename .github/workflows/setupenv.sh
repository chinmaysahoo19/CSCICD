#!/bin/bash
echo "MYKEY IS  - ${STAGE_API_KEY}"

echo "MYKEY IS  SECRECT  - ${SECRECT_STAGE_API_KEY}"

echo "myname=chinmaya" >> $GITHUB_OUTPUT
echo "GIT_SHA=${GIT_SHA}" >> $GITHUB_OUTPUT
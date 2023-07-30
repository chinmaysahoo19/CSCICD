#!/bin/bash
echo "${STAGE_API_KEY}"
echo "myname=chinmaya" >> $GITHUB_OUTPUT
echo "GIT_SHA=${GIT_SHA}" >> $GITHUB_OUTPUT
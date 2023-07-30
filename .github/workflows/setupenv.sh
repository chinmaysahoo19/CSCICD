#!/bin/bash

GIT_SHA=`echo -n ${{github.sha}}`
echo ::set-output name=GIT_SHA::${GIT_SHA}  ## Git latest SHA hash
echo "myname=chinmaya" >> $GITHUB_OUTPUT
echo "GIT_SHA=${GIT_SHA}" >> $GITHUB_OUTPUT
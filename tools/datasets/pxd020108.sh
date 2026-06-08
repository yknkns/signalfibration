#!/bin/sh

NAME="PXD020108"
OUTDIR="./data/$NAME"
URL="https://aacr.silverchair-cdn.com/aacr/content_public/journal/cancerres/81/11/10.1158_0008-5472.can-20-2435/3/00085472can202435-sup-247618_2_supp_6959277_qpwcsp.xlsx?Expires=1783920441&Signature=PJnSUOuMdL7ffi-8wMjYqNmEEyfJMeJHWJIzYU0Wo3ZFDUOSvylDuv1dAppe-PPWhG6-FPpXnGwqIWAvA9Ab4UxxBM3-tsX7kvoS6vuYqARSPJcPrfwy1l2it544QkCMGScAZDb3z~vCJXQ23-osPE0P-gg78A~VnzpNQ8KKUZBC5XRQPyKbqs~eURwPnCajm6ZRfl9hzJYhXMThB5JYXqkilX81h1dw8xu3yprXLD27eUHVyk5q4NjeIG3c699HT9JCbknxSzVsF5lFp6bysIuWJgpbDurhr6hoPHfhdeWX3JxaN3S1O9mOshADA5N2LH5v-L7k0DMEhPNTCSG82g__&Key-Pair-Id=APKAIE5G5CRDK6RD3PGA"

mkdir $OUTDIR
cd $OUTDIR
curl -O $URL

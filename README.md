# AVARL-DEMO

Simple AVAssetResourceLoaderDelegate Example Demonstrating Issue with Set-Cookie Header.

## Setup

1. Clone this project
2. Run using Simulator

## Steps to Reproduce Issue

1. Once App loads. Click Play Without Delegate button. Notice how playback works as expected.
2. Reopen App. Once App loads click Play With Delegate button. Notice video playback fails.

If you use charles and view the network requests made by the app you can find that with Step 2, the TS segment requests do not contain the cookie header but with Step 1 they do.
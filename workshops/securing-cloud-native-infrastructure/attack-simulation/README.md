# Attack simulation

This folder contains the attack simulation tooling for the workshop.

Important note: A sample C2 server is used to distribute the fake malware. This server is currently a DigitalOcean box, 143.198.125.69. To change it:

1. Do a search and replace in this folder
2. Make sure you have nginx installed on the new C2
3. Go to the `c2` folder and run `make deploy`. This will SCP the necessary files.

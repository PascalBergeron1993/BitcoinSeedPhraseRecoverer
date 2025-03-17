# Bitcoin Seed Phrase Recoverer

Bitcoin Seed Phrase Recoverer is a tool for people who are missing the last word (and only the last word) of their
BIP39 seed phrase. It works by taking advantage of the fact that the last word of a seed phrase is not purely random,
unlike the other words. 

As such, this tool makes your life easier because you don't have to try each of the 2048 entries in the BIP39 wordlist to
figure out what the last word of your seed phrase is. Instead, the wordlist is much shorter. For a seed phrase that is
comprised of 12 words, the wordlist is shortened to 128 entries; 15 words, 64 entries; 18 words, 32 entries; 21 words,
16 entries; and 24 words, 8 entries.

## Supported operating systems

- **Windows XP to Windows 11:** 32-bit (i386) and 64-bit (x86-64)
- **Linux:** 32-bit (i386) and 64-bit (x86-64), GTK 2 is required

## Technical information

The software is compiled with **Free Pascal Compiler 3.2.2** and **Lazarus 2.2.6, 64-bit (x86-64)**.

The **Windows binaries** are compiled on **Windows 10, 64-bit (x86-64)**.

The **Linux binaries** are cross-compiled on **Windows 10, 64-bit (x86-64)**.

## Has this software helped you?

Consider making a donation to the following Bitcoin address: bc1qu3fqvvdf0zks5lxqmpjtukg03r29jqtd2x78mx
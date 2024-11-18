# Notes

A collection of notes while this is in development.

## TODO

- Create template for users to copy
- Overlay custom functions on lib
- Think about moving away from Haumea

## Thoughts

- Outputs should be defined per architecture
- An individual output should call a `kosei` function
- That function should be a wrapper around lib.nixosSystem
- An individual output should self contain a system.
  - E.G. no universal user or system file you mix together
  - A user with the same name on different systems should be different
- The output file should use the kosei module system to create a
  compact declaration of the system and users.

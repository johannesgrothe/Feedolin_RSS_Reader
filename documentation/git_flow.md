# GitFlow and Git Style Guideline

## Branch- and Commit Format

- Main Branch: 'master'
  
  - Only gets commits by merging the development-branch into it after it has passed all the tests
  
  - Therefore only contains reviewed and tested code

- Development Branch: 'develop'
  
  - Only gety commits by merging a feature-branch into it after it has been reviewed
  
  - Therefore only contains reviewed code

- Feature Branches
  
  - Every feature branch has one issue attached to it
  
  - Every feature branch has the same structure:
    
    - structure: `fb_<issue nr>_<short_description>`
    
    - don't use spaces or special characters, only lower case letters and underscores
    
    - example: `fb_1_implement_basic_structure`
  
  - Every commit has the same structure:
    
    - structure: `#<issue nr> Commit message`
    
    - First letter of the message is a capital one, every other letter is lower case
    
    - example: `#1 Added xcode project`

## Git-Flow Diagram

![](git_flow.svg)

## Additional Guidelines

- Every contributer should only have a single issue 'In Progress' at a time. When you work on a second issue, move the first one into 'Waiting/Stuck' until you continue working on it
- Have as little active issues as possible

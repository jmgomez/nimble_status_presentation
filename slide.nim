import nimib, nimiSlides

nbInit(theme = revealTheme)


template feature(name: string, body: untyped) =
  discard
template dev(body: untyped) =
  feature "dev":
    body



slide: 
  nbText: """

What are we going to be talking about today?
- SAT Solvers
  - Enumerating Versions
- Declarative Parser
  - Feature Blocks
- Some small VSCode improvements:
  - VSCode highlights propagated exceptions
  - Better nimble integration with vscode
- Setup Nimble Action

"""


slide:
  slide:
    nbText: """
## Why SAT Solvers?

Traditional greedy solvers make locally optimal choices, often leading to dependency conflicts or suboptimal selections.

"""
  slide:
    column:
      nbText: """
  ## Example Issue:

  - Project A requires B >= 0.1.4 and C <= 0.1.0
  - Project B (version 0.1.4) depends on C (any version)
  - Project C has versions 0.1.0 and 0.2.1


  
    A greedy solver might pick C 0.2.1, breaking Project A’s constraints
"""

  slide:
    nbText: """
  # SAT Solver Advantage:
  - ✔ Global optimization: Ensures all dependencies are satisfied simultaneously
  - ✔ Backtracking & constraint solving: Finds a valid solution where C 0.1.0 is chosen
  - ✔ Correct & complete solutions: Avoids resolution failures that greedy solvers cannot handle

"""

  slide:
    nbText: """
  # Enumerating Versions: 
  Smarter Dependency Resolution:

  Traditional solvers pick a single version per package upfront, often leading to failures when dependencies are not satisfiable.


  """

  slide: 
    nbText: """
  ## New Approach:
  🔄 Iterative Version Selection: Instead of failing early, the solver downloads multiple versions and retries when conflicts arise.

"""

  slide:
    nbText: """
  ## How It Works:

  - If a dependency constraint allows any version, we fetch multiple versions
  - If the first attempted solution fails, we backtrack and try another version
  - This increases the chance of finding a valid solution automatically

"""

  slide:
    nbText: """
  ## Example:
  
  - A package requires B 0.1.4, which depends on C (any version)
  - If picking C 0.2.1 fails, the solver automatically tries C 0.1.0
  - The solver adapts dynamically to available versions, reducing resolution failures

"""

  slide:
    nbText: """
  ## Advantages:
  - ✔ More robust package resolution
  - ✔ Fewer manual fixes needed
  - ✔ Improved user experience

"""

slide:
  slide:
    nbText: """
  ## Declarative Parser 
  
  - 🚀 New in Nimble 0.18.0 
  - Enable with `--parser:declarative`
  - 🔜 Will become the default parser in future versions


"""
  slide:
    nbText: """
  ## Advantages:
  - ✔ Deterministic dependencies → Reliable caching
  - ✔ Improved speed → No need to spin up the Nim VM for every dependency
"""

  slide:
    nbText: """
  ## Conditional Dependencies with feature blocks

  - Supports optional dependencies
  - Avoids unnecessary packages when not needed

"""
  slide:
    nbText: """
  ## Example:
  A library supporting both asyncdispatch and chronos:

"""
    nbCode:
      #nimble file
      feature "chronos":
        require "chronos"


  slide:
    nbText: """
  ## Activating Features
    
  Command line  
    
    `nimble --feature:"chronos" install`

  Dependency level activation

    `require "awesomeAsyncPackage[chronos]"`

"""

  slide:
    nbText: """
  ## Checking Active Features in Code

"""
    nbCode:
      when defined(feature.awesomeAsyncPackage.chronos):
        import chronos
      else:
        import std/asyncdispatch

  slide:
    nbText: """
  ## The dev Feature
  Useful for development-specific dependencies

"""
    nbCode:
      feature "dev":
        require "unittest2"
    
    nbCode:
      #alias
      dev:
        require "unittest2"
    

slide:
  slide:
    nbText: "VSCode highlights propagated exceptions"
    nbImage("images/propagated_exceptions.png")

  slide:
    nbText: "Better nimble integration with vscode"
    nbImage("images/nimble_tasks.png")

slide: 
  nbText: "Setup Nimble Action"
  nbText:"""
```yaml
- name: Setup Nimble
        uses: nim-lang/setup-nimble-action@v1
        with:
          nimble-version: "latest"
          repo-token: ${{ secrets.GITHUB_TOKEN }}
```

"""
nbSave()



Executing a pipetree generated from declarative configuration.

This reduces conditionals at run-time,
Replaces clumsy module includes to inject or override features (in the correct order) with explicit, (visual!) pipelines
Speeds up as only the pipelines need to be run without too much decider code.


First used in the Representable gem.



Instead of implementing the perfect API where users can override methods, call `super` or inject their logic, let them construct their own workflow.

This is way less tedious than climbing through `super` calls and callstacks.


## TODO

* Catch exceptions and show where in the pipe they were raised.
* Statically compile pipetrees into Ruby methods to make it lightning fast (paid gem?)

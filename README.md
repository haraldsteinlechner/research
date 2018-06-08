A collection of my publications
========

This repository contains some papers, my thesis and other publications i would like to share with the world. All peer reviewed work is preprint only - the definite verison of the peer reviewed papers can be accessed via dl.acm.org. 


Peer reviewed publications:
--------------------------
* Andreas Walch, Christian Luksch, Attila Szabo, Harald Steinlechner, Georg Haaser, Michael
Schwarzler, Stefan Maierhofer , "Lens Flare Prediction based on Measurements with Real-Time Visualization” In: Proceedings of CGI 2018

* Ortner, T, Sorger, J, Steinlechner, H, Hesina, G, Piringer, H, Gröller, E, “Vis-A-Ware: Integrating Spatial and Non-Spatial Visualization for Visibility-Aware Urban Planning”. In: IEEE Transactions on Visualization and Computer Graphics 2016 (2016).

* Georg Haaser, Harald Steinlechner, Stefan Maierhofer, Robert F. Tobler, **An Incremental Rendering VM**, to appear at HPG '15 Proceedings of the 5th High-Performance Graphics Conference, [preprint: papers/AnIncrementalRenderingVM.pdf](/papers/AnIncrementalRenderingVM.pdf) print: http://dl.acm.org/citation.cfm?id=2790073

* Bernhard Urban, Harald Steinlechner, **Implementation of a Java Just-In-Time Compiler in Haskell**, PPPJ '13 Proceedings of the *2013* International Conference on Principles and Practices of Programming on the Java Platform: Virtual Machines, Languages, and Tools, [preprint: papers/MateVM.pdf](/papers/MateVM.pdf), [preprint, bernhards server](http://wien.tomnetworks.com/uni/2013_pppj_implementing_a_java_jit_compiler_in_haskell.pdf), print: http://dl.acm.org/citation.cfm?id=2500849

* Michael Wörister, Harald Steinlechner, Stefan Maierhofer, Robert F. Tobler, **Lazy incremental computation for efficient scene graph rendering**, HPG '13 Proceedings of the 5th High-Performance Graphics Conference, [preprint: papers/LazyIncrementalComputation.pdf](/papers/LazyIncrementalComputation.pdf), print: http://dl.acm.org/citation.cfm?id=2492051

  [Talk at HPG 2013](/papers/LazyIncrementalComputationSlides.pdf)
* Georg Haaser, Harald Steinlechner, Michael May, Michael Schwärzler, Stefan Maierhofer, Robert F. Tobler, **CoSMo: Intent-based Composition of Shader Modules**, Proceedings of International Conference on Computer Graphics Theory and Applications (Grapp 2014), [preprint: papers/Cosmo.pdf](/papers/Cosmo.pdf), print: http://www.scitepress.org/DigitalLibrary/Index/DOI/10.5220/0004687201890199

Student work and colloborations
--------------------------

todo

Other non peer reviewed publications
--------------------------

* Harald Steinlechner, **Attribute Grammars for Incremental Evaluation of Scene Graph Semantics**, *2014*, Master thesis, Vienna University of Technology, [thesis: papers/AttributeGrammarsForSceneGraphs.pdf](/papers/AttributeGrammarsForSceneGraphs.pdf) 
* Harald Steinlechner, **Compiling F# Functions for GPUs**, Bachelors thesis, Vienna University of Technology, [thesis: papers/FSharpForGPUs.pdf](/papers/FSharpForGPUs.pdf) 

Very old high school project thesis prior to my studies in CS:
* Severin Gassler, Georg Haaser, Harald Steinlechner, Manuel Wieser, **AUGUSTUS - Wirtschaftssimulation mittels Stategiespiel - Künstliche Intelligenz**, *2007*, High school project thesis, HTL Anichstraße, Innsbruck, Austria, [thesis: papers/Augustus_Diplomarbeit_Small.pdf](/papers/Augustus_Diplomarbeit_Small.pdf)


**Attribute Grammars for Incremental Evaluation of Scene Graph Semantics**
========
Three dimensional scenes are typically structured in a hierarchical way. 
This leads to scene graphs as a common central structure for the representation of virtual content. 
Although the concept of scene graphs is versatile and powerful, it has severe drawbacks.
Firstly, due to its hierarchical nature the communication between related nodes is cumbersome.
Secondly, changes in the virtual content make it necessary to traverse the whole scene graph at each frame. 
Although caching mechanisms for scene graphs have been proposed, none of them work for dynamic 
scenes with arbitrary changes.
Thirdly, state-of-the-art scene graph systems are limited in terms of extensibility.
Extending framework code with new node types usually requires the users to modify traversals and
the implementations of other nodes.
In this work, we use *attribute grammars* as underlying mechanism for specifying
scene graph semantics. 
We propose an embedded domain specific language for specifying scene graph semantics,
which elegantly solves the extensibility problem.
Attribute grammars provide well-founded mechanisms for communication between related nodes and
significantly reduce glue code for composing scene graph semantics.
The declarative nature of attribute grammars allows for side-effect free formulation
of scene graph semantics, which gives raise for incremental evaluation.

In contrast to previous work we use an expressive computation model for attribute grammar evaluation
which handles fully dynamic scene graph semantics while allowing for efficient *incremental evaluation*.

We introduce all necessary mechanisms for integrating incremental scene graph 
semantics with traditional rendering backends.
In our evaluation we show reduced development effort for standard scene graph
nodes. In addition to optimality proofs we show that our system is indeed
incremental and outperforms traditional scene graph systems in dynamic scenes.

[thesis: papers/AttributeGrammarsForSceneGraphs.pdf](/papers/AttributeGrammarsForSceneGraphs.pdf)


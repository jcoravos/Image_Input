Image_Input
===========

This repo contains code that facilitates input of image data into matlab, and the subsequent interpretation and display of that data. Other repositories exist for more invovled analysis packages (at the moment the only other one is CoM- and MoI-based analyses, which are in a sorry state as of this update.)

  There are two main groups of scripts here, classified based on the type of data they are designed to interpret.
   
    Unsegmented Data
      imseq_import
      imseq_MASTERscript
      shadedErrorBar
    
    Segmented EDGE Data
      LoadEdgeData_MASTER
      LoadEdgeDataConfig
      LoadEdgeDataFun
      sig_plot
      area_plot
      merge_area_plot
      merge_sig_plot
      interpEdge
      shadedErrorBar
      
    
  The first group is designed to run off an unsegmented image sequence. The second set of scripts and functions deals with segmented Edge data. LoadEdgeDataFun is designed to generate a useful data structure containing the useful information from an Edge data set in a single data structure that can then be interpreted by functions (like area plot) to generate figures. By running LoadEdgeDataConfig, LoadEdgeDataFun, you should have two structures, Input and Ouput, that can be used in a variety of other functions to interpret signal, area, etc., and display the information in plots. My hope is that the output structure can be a sort of universal structure for downstream analysis. This will be true at least in my own coding system.
  
  To use these scripts and functions, fork the repository into your own github account, and then clone the repository onto your remote. Then open the scripts and functions in MATLAB and read the directions (mostly in LoadEdgeDataConfig
  Jonathan Coravos - updated 05/11/14

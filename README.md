# intersectional-ai-safety
This repository contains the R code used for [*Intersectionality in Conversational AI Safety: How Bayesian Multilevel Models Help Understand Diverse Perceptions of Safety*](https://arxiv.org/abs/2306.11530). The underlying data are available as part of Google Research's [DICES Dataset](https://github.com/google-research-datasets/dices-dataset).

## Instructions
1. Download, pre-process, and save the DICES Data by running `preprocess_and_cache_data.R`.
2. With the pre-processed data, run the remaining R scripts beginning with `ad` (for models fit with all data) and `qs` (for models fit with data with qualitative risk severity ratings only).

## Requirements / Performance Tips
* Depending on your device, each model may take several hours to fit.
* The R scripts are set to run on a device with at least 8 CPU threads. We recommend you have at least 9 available.
* You can adjust number of threads used by editing the `cores` and `threads` arguments when calling `brm()`.
* Calculating model performance metrics is quite memory intensive. We recommend using a machine with at least 64 GB of RAM. Otherwise, comment out the performance code.
* You can run the scripts as background jobs either locally or remotely on an HPC cluster.

## Papers
[Intersectionality in Conversational AI Safety: How Bayesian Multilevel Models Help Understand Diverse Perceptions of Safety (2023)](https://arxiv.org/abs/2306.11530). Christopher M. Homan<sup>$\ast$</sup>, Gregory Serapio-García<sup>$\ast$</sup>, Lora Aroyo, Mark Díaz, Alicia Parrish, Vinodkumar Prabhakaran, Alex S. Taylor, and Ding Wang. 

[DICES Dataset: Diversity in Conversational AI Evaluation for Safety (2023)](https://arxiv.org/abs/2306.11247). Lora Aroyo<sup>$\ast$</sup>, Alex S. Taylor<sup>$\ast$</sup>, Mark Díaz, Christopher M. Homan, Alicia Parrish, Gregory Serapio-García, Vinodkumar Prabhakaran, and Ding Wang.

<sup>$\ast$</sup>Contributed equally. Subsequent coauthors listed alphabetically.

## Citation
If you use this code, please cite our [paper](https://arxiv.org/abs/2306.11530):
```bibtex
@misc{homan2023intersectionality,
      title={Intersectionality in Conversational AI Safety: How Bayesian Multilevel Models Help Understand Diverse Perceptions of Safety}, 
      author={Christopher M. Homan and Gregory Serapio-García and Lora Aroyo and Mark Díaz and Alicia Parrish and Vinodkumar Prabhakaran and Alex S. Taylor and Ding Wang},
      year={2023},
      eprint={2306.11530},
      archivePrefix={arXiv},
      primaryClass={cs.HC}
}
```

## License
Copyright 2023 Gregory Serapio-García

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

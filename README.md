# docker_build_optimized
This is a maven project with module dependency. The project focuses on creating a dockerfile so that building a image is faster when there is only code changes in the module.
As the docker reuses the layers to build a image, the same concept is used to optimize the build. However, there is no optimization when there is a dependency change in the pom file

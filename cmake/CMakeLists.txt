cmake_minimum_required(VERSION 3.26)

project(cmake-nix
  VERSION 1.0
  LANGUAGES CXX)

add_compile_options(-m32)
add_link_options(-m32)

add_executable(cmake-nix src/main.cpp)
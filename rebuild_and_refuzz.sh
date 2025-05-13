python3 infra/helper.py build_image libpng
sudo rm -r build/out/libpng
python3 infra/helper.py build_fuzzers libpng
mkdir -p build/out/corpus/
# store results to build/out/corpus
python3 infra/helper.py run_fuzzer libpng libpng_transformation_fuzzer --corpus-dir build/out/corpus

# rm -r build/out/libpng
# # for the one that play with zlib, use these commands
# python3 infra/helper.py build_fuzzers --sanitizer coverage zlib
# python3 infra/helper.py coverage zlib --corpus-dir build/out/corpus/
# --fuzz-target zlib_uncompress_fuzzer

#!/usr/bin/env sh

if [ -z "${SPI_SPEED}" ]; then
  SPI_SPEED=2000000
  export SPI_SPEED=$SPI_SPEED
fi

if [ -z "${ROOT_DIR}" ]; then
  ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
  export ROOT_DIR="$ROOT_DIR"
fi

if [ -z "${OUTPUT_DIR}" ]; then
  OUTPUT_DIR="$ROOT_DIR/outputs"
  export OUTPUT_DIR="$OUTPUT_DIR"
fi

echo "ROOT_DIR is $ROOT_DIR."
echo "OUTPUT_DIR is $OUTPUT_DIR."

compile_libloragw_for_spi_bus() {
    spi_bus="$1"
    echo "Compiling upstream libloragw for sx1301 on $spi_bus"

    # Compile libloragw (main library)
    cd "$ROOT_DIR/libloragw" || exit
    export SPI_DEV_DIR="/dev/$spi_bus"
    make clean
    make -j 4

    cd "$ROOT_DIR" || exit
    mkdir -p "$OUTPUT_DIR/$spi_bus/libloragw"
    cp "$ROOT_DIR/libloragw/libloragw.a" "$OUTPUT_DIR/$spi_bus/libloragw"
    cp "$ROOT_DIR/libloragw/test_loragw_cal" "$OUTPUT_DIR/$spi_bus/libloragw"
    cp "$ROOT_DIR/libloragw/test_loragw_gps" "$OUTPUT_DIR/$spi_bus/libloragw"
    cp "$ROOT_DIR/libloragw/test_loragw_hal" "$OUTPUT_DIR/$spi_bus/libloragw"
    cp "$ROOT_DIR/libloragw/test_loragw_reg" "$OUTPUT_DIR/$spi_bus/libloragw"
    cp "$ROOT_DIR/libloragw/test_loragw_spi" "$OUTPUT_DIR/$spi_bus/libloragw"

    # Compile util_pkt_logger
    cd "$ROOT_DIR/util_pkt_logger" || exit
    make clean
    make -j 4

    cd "$ROOT_DIR" || exit
    cp "$ROOT_DIR/util_pkt_logger/util_pkt_logger" "$OUTPUT_DIR/$spi_bus"

    # Compile util_tx_continuous
    cd "$ROOT_DIR/util_tx_continuous" || exit
    make clean
    make -j 4

    cd "$ROOT_DIR" || exit
    cp "$ROOT_DIR/util_tx_continuous/util_tx_continuous" "$OUTPUT_DIR/$spi_bus"

    # Compile util_tx_test
    cd "$ROOT_DIR/util_tx_test" || exit
    make clean
    make -j 4

    cd "$ROOT_DIR" || exit
    cp "$ROOT_DIR/util_tx_test/util_tx_test" "$OUTPUT_DIR/$spi_bus"

    # Compile util_spi_stress
    cd "$ROOT_DIR/util_spi_stress" || exit
    make clean
    make -j 4

    cd "$ROOT_DIR" || exit
    cp "$ROOT_DIR/util_spi_stress/util_spi_stress" "$OUTPUT_DIR/$spi_bus"

    # Compile util_spectral_scan
    cd "$ROOT_DIR/util_spectral_scan" || exit
    make clean
    make -j 4

    cd "$ROOT_DIR" || exit
    cp "$ROOT_DIR/util_spectral_scan/util_spectral_scan" "$OUTPUT_DIR/$spi_bus"

    # Compile util_lbt_test
    cd "$ROOT_DIR/util_lbt_test" || exit
    make clean
    make -j 4

    cd "$ROOT_DIR" || exit
    cp "$ROOT_DIR/util_lbt_test/util_lbt_test" "$OUTPUT_DIR/$spi_bus"

    echo "Finished building libloragw for sx1301 on $spi_bus in $OUTPUT_DIR"
}

compile_libloragw() {
    echo "Compiling libloragw for sx1301 concentrator on all the necessary SPI buses in $OUTPUT_DIR"

    # Built outputs will be copied to this directory
    mkdir -p "$OUTPUT_DIR"

    # In order to be more portable, intentionally not interating over an array
    compile_libloragw_for_spi_bus spidev0.0
    compile_libloragw_for_spi_bus spidev0.1
    compile_libloragw_for_spi_bus spidev1.0
    compile_libloragw_for_spi_bus spidev1.1
    compile_libloragw_for_spi_bus spidev1.2
    compile_libloragw_for_spi_bus spidev2.0
    compile_libloragw_for_spi_bus spidev2.1
    compile_libloragw_for_spi_bus spidev2.2
    compile_libloragw_for_spi_bus spidev2.3
    compile_libloragw_for_spi_bus spidev32766.0
}

compile_libloragw

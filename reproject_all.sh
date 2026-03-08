#!/bin/bash
# Reproject all Landsat bands to CA Zone 5

for band in B2 B3 B4 B5 B6 B7 B8 B9 B10 B11; do
    echo "Processing band $band..."
    
    # Find the file (handles different naming patterns)
    input_file=$(ls original/*${band}.TIF 2>/dev/null | head -1)
    
    if [ -f "$input_file" ]; then
        gdalwarp \
            -t_srs EPSG:2229 \
            -r cubic \
            -of GTiff \
            -co COMPRESS=DEFLATE \
            -co TILED=YES \
            -co NUM_THREADS=ALL_CPUS \
            "$input_file" \
            "reprojected/CAZ5_${band}.tif"
        echo "✅ Completed $band"
    else
        echo "❌ File for band $band not found"
    fi
done

echo "All bands reprojected!"

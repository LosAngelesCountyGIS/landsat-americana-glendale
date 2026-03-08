#!/bin/bash
# ============================================================================
# CREATE RGB COMPOSITE - CLEAN VERSION
# ============================================================================
# This script combines individual bands into a single RGB GeoTIFF
# Input:  reprojected/CAZ5_B2.tif (Blue)
#         reprojected/CAZ5_B3.tif (Green)
#         reprojected/CAZ5_B4.tif (Red)
# Output: rgb/Americana_RGB.tif (3 bands, full color)
# ============================================================================

# Navigate to project folder
cd ~/landsat-americana-glendale

echo "======================================================================"
echo "CREATE RGB COMPOSITE"
echo "======================================================================"
echo ""

# Remove existing rgb folder and create fresh one
echo "📁 Setting up folders..."
rm -rf rgb
mkdir -p rgb
echo "✅ Created: rgb/"
echo ""

# Check if reprojected files exist
echo "🔍 Checking band files..."
FILES_MISSING=0

if [ ! -f reprojected/CAZ5_B2.tif ]; then
    echo "   ❌ Missing: reprojected/CAZ5_B2.tif (Blue band)"
    FILES_MISSING=1
else
    echo "   ✅ Found: Blue band (reprojected/CAZ5_B2.tif)"
fi

if [ ! -f reprojected/CAZ5_B3.tif ]; then
    echo "   ❌ Missing: reprojected/CAZ5_B3.tif (Green band)"
    FILES_MISSING=1
else
    echo "   ✅ Found: Green band (reprojected/CAZ5_B3.tif)"
fi

if [ ! -f reprojected/CAZ5_B4.tif ]; then
    echo "   ❌ Missing: reprojected/CAZ5_B4.tif (Red band)"
    FILES_MISSING=1
else
    echo "   ✅ Found: Red band (reprojected/CAZ5_B4.tif)"
fi

if [ $FILES_MISSING -eq 1 ]; then
    echo ""
    echo "❌ ERROR: Missing band files. Please run reprojection first."
    exit 1
fi
echo ""

# Show file sizes
echo "📊 Band file sizes:"
BLUE_SIZE=$(du -h reprojected/CAZ5_B2.tif | cut -f1)
GREEN_SIZE=$(du -h reprojected/CAZ5_B3.tif | cut -f1)
RED_SIZE=$(du -h reprojected/CAZ5_B4.tif | cut -f1)

echo "   • Blue band:  $BLUE_SIZE"
echo "   • Green band: $GREEN_SIZE"
echo "   • Red band:   $RED_SIZE"
echo ""

# Create RGB composite
echo "🎨 Creating RGB composite..."
echo "   Band order:"
echo "   • Band 1 = Red   (from CAZ5_B4.tif)"
echo "   • Band 2 = Green (from CAZ5_B3.tif)"
echo "   • Band 3 = Blue  (from CAZ5_B2.tif)"
echo ""

gdal_merge.py -separate \
    -of GTiff \
    -co COMPRESS=DEFLATE \
    -co TILED=YES \
    -co PHOTOMETRIC=RGB \
    -co NUM_THREADS=ALL_CPUS \
    -o rgb/Americana_RGB.tif \
    reprojected/CAZ5_B4.tif \
    reprojected/CAZ5_B3.tif \
    reprojected/CAZ5_B2.tif

# Check if RGB was created
if [ -f rgb/Americana_RGB.tif ]; then
    RGB_SIZE=$(du -h rgb/Americana_RGB.tif | cut -f1)
    echo "✅ RGB composite created: rgb/Americana_RGB.tif"
    echo "   • Size: $RGB_SIZE"
else
    echo "❌ Failed to create RGB composite"
    exit 1
fi
echo ""

# Set correct color interpretation
echo "🎯 Setting color interpretation..."
gdal_edit.py -colorinterp_1 Red -colorinterp_2 Green -colorinterp_3 Blue rgb/Americana_RGB.tif
echo "✅ Color interpretation set: Band1=Red, Band2=Green, Band3=Blue"
echo ""

# Verify RGB file
echo "🔍 Verifying RGB file..."
echo ""

# Check bands
echo "📋 Band information:"
gdalinfo rgb/Americana_RGB.tif | grep -A3 "Band" | head -9
echo ""

# Check band statistics (should be different)
echo "📊 Band statistics (different values = color data exists):"
STATS=$(gdalinfo -stats rgb/Americana_RGB.tif | grep "STATISTICS_MEAN")
if [ -n "$STATS" ]; then
    echo "$STATS" | sed 's/^/   /'
    
    # Extract values to prove they're different
    MEAN1=$(gdalinfo -stats rgb/Americana_RGB.tif | grep "STATISTICS_MEAN" | sed -n '1p' | cut -d= -f2)
    MEAN2=$(gdalinfo -stats rgb/Americana_RGB.tif | grep "STATISTICS_MEAN" | sed -n '2p' | cut -d= -f2)
    MEAN3=$(gdalinfo -stats rgb/Americana_RGB.tif | grep "STATISTICS_MEAN" | sed -n '3p' | cut -d= -f2)
    
    echo ""
    echo "   📈 Mean values comparison:"
    echo "      • Band 1 (Red):   $MEAN1"
    echo "      • Band 2 (Green): $MEAN2"
    echo "      • Band 3 (Blue):  $MEAN3"
    
    if [ "$MEAN1" != "$MEAN2" ] || [ "$MEAN1" != "$MEAN3" ]; then
        echo "      ✅ Bands have different values - COLOR DATA CONFIRMED!"
    else
        echo "      ⚠️  Bands have similar values - may be grayscale"
    fi
fi
echo ""

# Count bands
BAND_COUNT=$(gdalinfo rgb/Americana_RGB.tif | grep -c "Band")
if [ "$BAND_COUNT" -eq 3 ]; then
    echo "✅ Correct: File has $BAND_COUNT bands"
else
    echo "❌ Error: File has $BAND_COUNT bands (should be 3)"
fi
echo ""

# Check projection
echo "🗺️  Projection:"
gdalinfo rgb/Americana_RGB.tif | grep -A1 "Coordinate System" | tail -1 | sed 's/^/   /'
echo ""

echo "======================================================================"
echo "✅ RGB CREATION COMPLETE"
echo "======================================================================"
echo ""
echo "📁 Output: rgb/Americana_RGB.tif"
echo "   • Size: $RGB_SIZE"
echo "   • Bands: 3 (Red, Green, Blue)"
echo "   • Projection: NAD83 / California Zone 5 (EPSG:2229)"
echo "   • Compression: DEFLATE"
echo "   • Tiled: Yes"
echo ""
echo "🚀 Next step: Run 02_create_cog.sh"
echo "   ./02_create_cog.sh"
echo ""
echo "🌍 Quick QGIS check:"
echo "   qgis rgb/Americana_RGB.tif &"
echo "   (If grayscale, change Render type to 'Multiband color')"
echo ""
echo "======================================================================"
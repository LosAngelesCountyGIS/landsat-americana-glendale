#!/bin/bash
# ============================================================================
# CREATE CLOUD OPTIMIZED GEOTIFF (COG) - FINAL WORKING VERSION
# ============================================================================
# This script converts RGB to a proper COG with multiple resolution pages
# Input:  rgb/Americana_RGB.tif
# Output: cog/Americana_RGB_COG.tif (3 bands + automatic overviews)
# ============================================================================

cd ~/landsat-americana-glendale

echo "======================================================================"
echo "CREATING CLOUD OPTIMIZED GEOTIFF"
echo "======================================================================"
echo ""

# Create fresh cog folder
rm -rf cog
mkdir -p cog
echo "✅ Created: cog/"

# Check if RGB file exists
if [ ! -f rgb/Americana_RGB.tif ]; then
    echo "❌ ERROR: RGB file not found!"
    exit 1
fi

echo "✅ Found RGB file: rgb/Americana_RGB.tif"
echo ""

# Create COG (GDAL automatically adds overviews)
echo "☁️ Creating Cloud Optimized GeoTIFF..."
gdal_translate -of COG \
    rgb/Americana_RGB.tif \
    cog/Americana_RGB_COG.tif

echo "✅ COG created: cog/Americana_RGB_COG.tif"
echo ""

# Verify the COG has multiple pages
echo "📊 COG Structure:"
gdalinfo cog/Americana_RGB_COG.tif | grep -E "Band|Overviews" | head -10

# Count pages
BANDS=$(gdalinfo cog/Americana_RGB_COG.tif | grep -c "Band")
OVERVIEWS=$(gdalinfo cog/Americana_RGB_COG.tif | grep -c "Overview [0-9]")

echo ""
echo "📋 Summary:"
echo "   • Color bands: $BANDS (Red, Green, Blue)"
echo "   • Overview pages: $OVERVIEWS"
echo "   • Total pages: $((BANDS + OVERVIEWS))"
echo ""

echo "======================================================================"
echo "✅ DONE! Open in QGIS:"
echo "   qgis cog/Americana_RGB_COG.tif &"
echo "======================================================================"
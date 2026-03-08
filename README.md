# 🌎 **Landsat Americana at Brand - Glendale, CA**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GDAL](https://img.shields.io/badge/GDAL-3.4+-green)](https://gdal.org)
[![QGIS](https://img.shields.io/badge/QGIS-3.34+-blue)](https://qgis.org)
[![Landsat](https://img.shields.io/badge/Landsat-9-red)](https://www.usgs.gov/landsat-missions/landsat-9)
[![USGS](https://img.shields.io/badge/data-USGS-brown)](https://earthexplorer.usgs.gov)

> **A complete workflow to download, reproject, and visualize Landsat 9 imagery for The Americana at Brand in Glendale, California, converted to NAD83 / California Zone 5 (EPSG:2229) - the official LA County standard.**

---

## 📋 **Table of Contents**
- [Project Overview](#project-overview)
- [📍 Location](#-location)
- [🛰️ Data Source](#️-data-source)
- [📊 Scene Details](#-scene-details)
- [📁 Repository Structure](#-repository-structure)
- [🚀 Quick Start](#-quick-start)
- [📥 Download Instructions](#-download-instructions)
- [🔄 Reprojection Workflow](#-reprojection-workflow)
- [🌈 Creating RGB Composites](#-creating-rgb-composites)
- [📸 VRT vs GeoTIFF](#-vrt-vs-geotiff)
- [📝 License](#-license)

---

## 🎯 **Project Overview**

This repository provides a complete, step-by-step guide to:

✅ Download **Landsat 9** imagery for **The Americana at Brand** in Glendale, CA  
✅ Reproject from **UTM Zone 11N (EPSG:32611)** to **NAD83 / California Zone 5 (EPSG:2229)**  
✅ Create **Cloud Optimized GeoTIFFs (COGs)** for fast streaming  
✅ Build **RGB color composites** with correct band ordering  
✅ Generate both **VRT (virtual)** and **physical GeoTIFF** files  
✅ Visualize in **QGIS** with proper projection verification  

---

## 📍 **Location**

<div align="center">

| **Parameter** | **Value** |
|:-------------:|:---------:|
| **Place** | The Americana at Brand, Glendale, CA |
| **Latitude** | `34.1446° N` |
| **Longitude** | `-118.2551° W` |
| **Radius** | `1000 meters` |

</div>

---

## 🛰️ **Data Source**

This project uses **Landsat 8-9 OLI/TIRS Collection 2 Level-1** data from the [USGS EarthExplorer](https://earthexplorer.usgs.gov).

### Selection Hierarchy
┌─────────────────────────────────────────────────────────┐
│ USGS EarthExplorer │
└─────────────────────────────────────────────────────────┘
│
▼
┌─────────────────────────────────────────────────────────┐
│ Landsat │
└─────────────────────────────────────────────────────────┘
│
▼
┌─────────────────────────────────────────────────────────┐
│ Landsat Collection 2 │
└─────────────────────────────────────────────────────────┘
│
▼
┌─────────────────────────────────────────────────────────┐
│ Level-1 │
└─────────────────────────────────────────────────────────┘
│
▼
┌─────────────────────────────────────────────────────────┐
│ Landsat 8-9 OLI/TIRS C2 L1 ← YOU ARE HERE! │
└─────────────────────────────────────────────────────────┘
│
▼
┌─────────────────────────────────────────────────────────┐
│ LC09_L1TP_041036_20241229_20241229_02_T1 │
│ ┌──────────┬──────────┬──────────┬──────────┬────────┐ │
│ │ B1.TIF │ B2.TIF │ B3.TIF │ B4.TIF │ B5.TIF │ │
│ │(Coastal) │ (Blue) │ (Green) │ (Red) │ (NIR) │ │
│ ├──────────┼──────────┼──────────┼──────────┼────────┤ │
│ │ B6.TIF │ B7.TIF │ B8.TIF │ B9.TIF │...more│ │
│ │ (SWIR1) │ (SWIR2) │ (Pan) │ (Cirrus) │ │ │
│ └──────────┴──────────┴──────────┴──────────┴────────┘ │
└─────────────────────────────────────────────────────────┘



### File Identifier Breakdown

| **Component** | **Value** | **Meaning** |
|:-------------:|:---------:|:-----------:|
| **Satellite** | `LC09` | Landsat 9 |
| **Level** | `L1TP` | Level-1 Terrain Precision |
| **Path/Row** | `041036` | Path 041, Row 036 (Glendale area) |
| **Acquisition** | `20241229` | December 29, 2024 |
| **Collection** | `02` | Collection 2 |
| **Tier** | `T1` | Tier 1 (highest quality) |

---

## 📊 **Scene Details**

<div align="center">

| **Property** | **Value** |
|:------------:|:---------:|
| **Satellite** | 🛰️ Landsat 9 |
| **Scene ID** | `LC09_L1TP_041036_20241229_20241229_02_T1` |
| **Acquisition Date** | 📅 December 29, 2024 |
| **Path / Row** | 041 / 036 |
| **Cloud Cover** | ☁️ ~2.3% |
| **Original CRS** | UTM Zone 11N (EPSG:32611) |
| **Original Units** | Meters |
| **Target CRS** | NAD83 / California Zone 5 (EPSG:2229) |
| **Target Units** | US Survey Feet |

</div>

### Bands Used for RGB Composite

| **Band** | **Channel** | **File** | **Purpose** |
|:--------:|:-----------:|:--------:|:-----------:|
| **Band 2** | 🔵 Blue | `*_B2.TIF` | RGB Blue channel |
| **Band 3** | 🟢 Green | `*_B3.TIF` | RGB Green channel |
| **Band 4** | 🔴 Red | `*_B4.TIF` | RGB Red channel |

---

## 📁 **Repository Structure**

### File Identifier Breakdown

| **Component** | **Value** | **Meaning** |
|:-------------:|:---------:|:-----------:|
| **Satellite** | `LC09` | Landsat 9 |
| **Level** | `L1TP` | Level-1 Terrain Precision |
| **Path/Row** | `041036` | Path 041, Row 036 (Glendale area) |
| **Acquisition** | `20241229` | December 29, 2024 |
| **Collection** | `02` | Collection 2 |
| **Tier** | `T1` | Tier 1 (highest quality) |

---

## 📊 **Scene Details**

<div align="center">

| **Property** | **Value** |
|:------------:|:---------:|
| **Satellite** | 🛰️ Landsat 9 |
| **Scene ID** | `LC09_L1TP_041036_20241229_20241229_02_T1` |
| **Acquisition Date** | 📅 December 29, 2024 |
| **Path / Row** | 041 / 036 |
| **Cloud Cover** | ☁️ ~2.3% |
| **Original CRS** | UTM Zone 11N (EPSG:32611) |
| **Original Units** | Meters |
| **Target CRS** | NAD83 / California Zone 5 (EPSG:2229) |
| **Target Units** | US Survey Feet |

</div>

### Bands Used for RGB Composite

| **Band** | **Channel** | **File** | **Purpose** |
|:--------:|:-----------:|:--------:|:-----------:|
| **Band 2** | 🔵 Blue | `*_B2.TIF` | RGB Blue channel |
| **Band 3** | 🟢 Green | `*_B3.TIF` | RGB Green channel |
| **Band 4** | 🔴 Red | `*_B4.TIF` | RGB Red channel |

---

## 📁 **Repository Structure**
📦 landsat-americana-glendale
├── 📄 README.md # This file
├── 📂 scripts/
│ ├── 🐍 explore_data.py # Inspect Landsat files
│ ├── 🐍 reproject.py # Convert to CA Zone 5
│ ├── 🐍 create_vrt.py # Make RGB VRT composite
│ ├── 🐍 create_tiff.py # Make physical GeoTIFF
│ └── 🐍 batch_process.py # Run everything at once
├── 📂 docs/
│ ├── 📄 GDAL_COMMANDS.md # GDAL cheatsheet
│ ├── 📄 BAND_ORDER.md # Understanding RGB order
│ └── 📄 TIFF_VS_GEOTIFF.md # Format explanations
└── 📂 examples/
└── 📄 analysis_examples.md # Sample analyses



---

## 🚀 **Quick Start**

### Prerequisites

```bash
# Install required software
sudo apt-get update
sudo apt-get install -y gdal-bin python3-gdal qgis

# Verify installations
gdalinfo --version
qgis --version

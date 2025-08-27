#!/usr/bin/env python3
import os
from PIL import Image, ImageDraw, ImageFont
import json

def create_icon(size):
    """Create a golf-themed Format Finder app icon"""
    # Create a new image with green gradient background
    img = Image.new('RGB', (size, size), color=(46, 125, 50))
    draw = ImageDraw.Draw(img)
    
    # Create gradient effect
    for y in range(size):
        # Gradient from darker green to lighter green
        color_value = int(46 + (70 * (y / size)))
        green_value = int(125 - (25 * (y / size)))
        draw.rectangle([(0, y), (size, y+1)], fill=(color_value, green_value, 50))
    
    # Draw a golf ball pattern in the center
    center_x = size // 2
    center_y = size // 2
    ball_radius = int(size * 0.3)
    
    # White circle for golf ball
    draw.ellipse(
        [center_x - ball_radius, center_y - ball_radius, 
         center_x + ball_radius, center_y + ball_radius],
        fill=(255, 255, 255)
    )
    
    # Add dimple pattern to golf ball
    dimple_size = max(2, int(size * 0.02))
    dimple_spacing = max(8, int(size * 0.05))
    
    for x in range(center_x - ball_radius + dimple_spacing, center_x + ball_radius, dimple_spacing):
        for y in range(center_y - ball_radius + dimple_spacing, center_y + ball_radius, dimple_spacing):
            # Check if dimple is within the circle
            if ((x - center_x) ** 2 + (y - center_y) ** 2) < (ball_radius - dimple_size) ** 2:
                draw.ellipse(
                    [x - dimple_size, y - dimple_size, 
                     x + dimple_size, y + dimple_size],
                    fill=(230, 230, 230)
                )
    
    # Draw a magnifying glass overlay to represent "finding/searching"
    glass_radius = int(size * 0.15)
    glass_x = center_x + int(ball_radius * 0.5)
    glass_y = center_y - int(ball_radius * 0.5)
    
    # Glass circle
    draw.ellipse(
        [glass_x - glass_radius, glass_y - glass_radius,
         glass_x + glass_radius, glass_y + glass_radius],
        outline=(30, 80, 30), width=max(3, int(size * 0.02))
    )
    
    # Glass handle
    handle_start_x = glass_x + int(glass_radius * 0.7)
    handle_start_y = glass_y + int(glass_radius * 0.7)
    handle_end_x = glass_x + int(glass_radius * 1.5)
    handle_end_y = glass_y + int(glass_radius * 1.5)
    draw.line(
        [handle_start_x, handle_start_y, handle_end_x, handle_end_y],
        fill=(30, 80, 30), width=max(3, int(size * 0.02))
    )
    
    # Add flag symbol in corner
    flag_x = int(size * 0.75)
    flag_y = int(size * 0.25)
    pole_height = int(size * 0.15)
    
    # Draw pole
    draw.line(
        [flag_x, flag_y, flag_x, flag_y + pole_height],
        fill=(200, 50, 50), width=max(2, int(size * 0.01))
    )
    
    # Draw flag
    flag_points = [
        (flag_x, flag_y),
        (flag_x + int(size * 0.08), flag_y + int(size * 0.03)),
        (flag_x, flag_y + int(size * 0.06))
    ]
    draw.polygon(flag_points, fill=(200, 50, 50))
    
    return img

def generate_ios_icons():
    """Generate all required iOS app icon sizes"""
    
    # iOS App Icon sizes (in points, will be saved at 1x, 2x, 3x)
    icon_sizes = {
        # iPhone Notification
        "20x20@2x": 40,
        "20x20@3x": 60,
        # iPhone Settings
        "29x29@2x": 58,
        "29x29@3x": 87,
        # iPhone Spotlight
        "40x40@2x": 80,
        "40x40@3x": 120,
        # iPhone App
        "60x60@2x": 120,
        "60x60@3x": 180,
        # iPad Notification
        "20x20@1x": 20,
        "20x20@2x": 40,
        # iPad Settings
        "29x29@1x": 29,
        "29x29@2x": 58,
        # iPad Spotlight
        "40x40@1x": 40,
        "40x40@2x": 80,
        # iPad App
        "76x76@1x": 76,
        "76x76@2x": 152,
        # iPad Pro App
        "83.5x83.5@2x": 167,
        # App Store
        "1024x1024@1x": 1024
    }
    
    # Create output directory
    output_dir = "/Users/connormurphy/Desktop/Format Finder/app-icon/FormatFinder/Assets.xcassets/AppIcon.appiconset"
    os.makedirs(output_dir, exist_ok=True)
    
    # Contents.json for Asset Catalog
    contents = {
        "images": [],
        "info": {
            "author": "xcode",
            "version": 1
        }
    }
    
    for name, size in icon_sizes.items():
        # Generate icon
        icon = create_icon(size)
        
        # Save icon
        filename = f"icon_{name}.png"
        filepath = os.path.join(output_dir, filename)
        icon.save(filepath, "PNG")
        print(f"Generated: {filename} ({size}x{size}px)")
        
        # Parse size info for Contents.json
        base_size = name.split('@')[0]
        scale = name.split('@')[1] if '@' in name else "1x"
        width, height = base_size.split('x')
        
        # Determine idiom
        if "1024x1024" in name:
            idiom = "ios-marketing"
        elif int(width.replace('.5', '')) >= 76:
            idiom = "ipad"
        else:
            idiom = "iphone"
        
        # Add to contents
        image_info = {
            "filename": filename,
            "idiom": idiom,
            "scale": scale,
            "size": base_size
        }
        contents["images"].append(image_info)
    
    # Save Contents.json
    contents_path = os.path.join(output_dir, "Contents.json")
    with open(contents_path, 'w') as f:
        json.dump(contents, f, indent=2)
    
    print(f"\nGenerated Contents.json at: {contents_path}")
    print("\nAll icons generated successfully!")

if __name__ == "__main__":
    print("Generating Format Finder app icons...")
    generate_ios_icons()
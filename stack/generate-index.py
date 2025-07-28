#!/usr/bin/python3

import os

def generate_index_html(directory, root_dir):
    """
    Generates an index.html file in the specified directory listing all files and subdirectories.
    Includes font-switching buttons and a link to navigate back to the home directory.

    Parameters:
    - directory (str): The directory in which to create the index.html.
    - root_dir (str): The root directory from which the script started.
    """
    # List all non-hidden items
    items = [item for item in os.listdir(directory) if not item.startswith('.')]
    items.sort(key=lambda x: (not os.path.isdir(os.path.join(directory, x)), x.lower()))  # Directories first

    # Separate directories and files
    dirs = [d for d in items if os.path.isdir(os.path.join(directory, d))]
    files = [f for f in items if os.path.isfile(os.path.join(directory, f))]

    # Compute relative path from current directory to fonts_dir
    fonts_dir = os.path.join(root_dir, 'fonts')
    relative_fonts_path = os.path.relpath(fonts_dir, directory).replace('\\', '/')

    # Build @font-face CSS with relative paths
    font_face_css = f"""
        @font-face {{
            font-family: 'Standard Galactic';
            src: url('{relative_fonts_path}/Sga-Regular.ttf') format('truetype');
            font-weight: normal;
            font-style: normal;
        }}
        @font-face {{
            font-family: 'Cursive Galactic';
            src: url('{relative_fonts_path}/CursiveGalactic-Regular.ttf') format('truetype');
            font-weight: normal;
            font-style: normal;
        }}
        @font-face {{
            font-family: 'Clypto';
            src: url('{relative_fonts_path}/Clypto-Regular.ttf') format('truetype');
            font-weight: normal;
            font-style: normal;
        }}
        @font-face {{
            font-family: 'Cheiro';
            src: url('{relative_fonts_path}/Cheiro-Regular.ttf') format('truetype');
            font-weight: normal;
            font-style: normal;
        }}
        @font-face {{
            font-family: 'Dactyl';
            src: url('{relative_fonts_path}/Dactyl.ttf') format('truetype');
            font-weight: normal;
            font-style: normal;
        }}
    """

    # Determine if we're in the root directory
    is_root = os.path.abspath(directory) == os.path.abspath(root_dir)

    # If not root, add a "Back to Home" link
    back_link_html = ""
    if not is_root:
        # Compute relative path to root index.html
        back_link = os.path.relpath(root_dir, directory).replace('\\', '/')
        back_link_html = f'        <li>⬅ <a href="{back_link}/index.html">Back to Home</a></li>\n'

    # HTML content
    html_content = f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Directory Listing: {os.path.basename(os.path.abspath(directory))}</title>
    <style>
        {font_face_css}

        /* Base styling */
        body {{
            font-family: 'Standard Galactic', Arial, sans-serif;
            color: #00ff00;
            background: #1e1e1e;
            margin: 0;
            padding: 20px;
        }}
        h1, h2 {{
            text-align: center;
            color: #00ff00;
        }}
        ul {{
            list-style-type: none;
            padding: 0;
            max-width: 800px;
            margin: 0 auto;
        }}
        li {{
            margin: 5px 0;
        }}
        a {{
            color: #00ff00;
            text-decoration: none;
        }}
        a:hover {{
            text-decoration: underline;
            color: #00cc00;
        }}
        .button-container {{
            text-align: center;
            margin-bottom: 20px;
        }}
        /* Button styles with respective fonts */
        .font-button {{
            padding: 8px 16px;
            margin: 0 5px;
            border: 2px solid #00ff00;
            background: transparent;
            color: #00ff00;
            cursor: pointer;
            font-size: 1em;
            transition: background 0.3s, color 0.3s;
        }}
        .font-button:hover {{
            background: #00ff00;
            color: #1e1e1e;
        }}
        /* Specific font styles for buttons */
        .sga-btn {{
            font-family: 'Standard Galactic', Arial, sans-serif;
        }}
        .cursive-btn {{
            font-family: 'Cursive Galactic', Arial, sans-serif;
        }}
        .clypto-btn {{
            font-family: 'Clypto', Arial, sans-serif;
        }}
        .cheiro-btn {{
            font-family: 'Cheiro', Arial, sans-serif;
        }}
        .courier-btn {{
            font-family: 'Courier', monospace;
        }}
    </style>
</head>
<body>
    <h1>Directory Listing: {os.path.basename(os.path.abspath(directory))}</h1>

    <div class="button-container">
        <!-- Font-switching buttons (order: SGA, Cursive Galactic, Clypto, Cheiro, Courier) -->
        <button class="font-button sga-btn" onclick="switchFont('Standard Galactic')">SGA</button>
        <button class="font-button cursive-btn" onclick="switchFont('Cursive Galactic')">Cursive Galactic</button>
        <button class="font-button clypto-btn" onclick="switchFont('Clypto')">Clypto</button>
        <button class="font-button cheiro-btn" onclick="switchFont('Cheiro')">Cheiro</button>
        <button class="font-button courier-btn" onclick="switchFont('Courier')">Courier</button>
    </div>

    <ul>
{back_link_html}"""

    # Add directories
    for d in dirs:
        # Ensure links end with '/' to indicate directories
        html_content += f'        <li>📁 <a href="{d}/index.html">{d}/</a></li>\n'

    # Add files
    for f in files:
        if f == 'index.html':
            continue  # Skip the index.html itself
        html_content += f'        <li>📄 <a href="{f}">{f}</a></li>\n'

    # Close the unordered list and add JavaScript
    html_content += """    </ul>

    <script>
        function switchFont(fontName) {
            if (fontName === 'Clypto') {
                document.body.style.fontFamily = "'Clypto', 'Dactyl', Arial, sans-serif";
            } else if (fontName === 'Cheiro') {
                document.body.style.fontFamily = "'Cheiro', 'Standard Galactic', Arial, sans-serif";
            } else if (fontName === 'Courier') {
                document.body.style.fontFamily = "'Courier', monospace";
            } else {
                document.body.style.fontFamily = `'${fontName}', Arial, sans-serif`;
            }
        }
    </script>
</body>
</html>
"""

    # Write the index.html file
    index_path = os.path.join(directory, 'index.html')
    with open(index_path, 'w', encoding='utf-8') as f:
        f.write(html_content)
    print(f"Created index.html in: {directory}")

def generate_recursive_indexes(root_dir):
    """
    Recursively generate index.html files starting from root_dir.

    Parameters:
    - root_dir (str): The root directory to start generating index.html files.
    """
    root_dir = os.path.abspath(root_dir)
    fonts_dir = os.path.join(root_dir, 'fonts')

    if not os.path.exists(fonts_dir):
        print(f"Error: 'fonts' directory not found in {root_dir}. Please ensure the 'fonts' folder exists.")
        return

    for current_dir, dirs, files in os.walk(root_dir):
        generate_index_html(current_dir, root_dir)

if __name__ == "__main__":
    # Start generating from the current directory
    generate_recursive_indexes(".")

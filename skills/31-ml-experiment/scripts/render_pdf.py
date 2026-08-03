#!/usr/bin/env python3
"""
HTML to PDF Converter Script for A4 Executive Reports.
Attempts conversion using:
1. WeasyPrint (Python library)
2. Playwright (Headless Chromium)
3. Headless Chrome / Chromium / Edge CLI
4. xhtml2pdf / pdfkit
"""

import sys
import os
import argparse
import subprocess
import shutil

def convert_html_to_pdf(input_html: str, output_pdf: str) -> bool:
    input_html = os.path.abspath(input_html)
    output_pdf = os.path.abspath(output_pdf)

    if not os.path.exists(input_html):
        print(f"Error: Input HTML file not found: {input_html}")
        return False

    os.makedirs(os.path.dirname(output_pdf), exist_ok=True)

    # Strategy 1: WeasyPrint
    try:
        from weasyprint import HTML
        print(f"[Engine: WeasyPrint] Converting {input_html} -> {output_pdf}...")
        HTML(filename=input_html).write_pdf(output_pdf)
        print("PDF generated successfully via WeasyPrint.")
        return True
    except ImportError:
        pass
    except Exception as e:
        print(f"WeasyPrint failed: {e}")

    # Strategy 2: Playwright
    try:
        from playwright.sync_api import sync_playwright
        print(f"[Engine: Playwright] Converting {input_html} -> {output_pdf}...")
        with sync_playwright() as p:
            browser = p.chromium.launch()
            page = browser.new_page()
            page.goto(f"file://{input_html}", wait_until="networkidle")
            page.pdf(path=output_pdf, format="A4", print_background=True, margin={"top": "20mm", "bottom": "20mm", "left": "15mm", "right": "15mm"})
            browser.close()
        print("PDF generated successfully via Playwright.")
        return True
    except ImportError:
        pass
    except Exception as e:
        print(f"Playwright failed: {e}")

    # Strategy 3: Headless Chrome / Chromium / Edge CLI
    browsers = ["google-chrome", "chromium", "chromium-browser", "msedge"]
    for b in browsers:
        cmd_path = shutil.which(b)
        if cmd_path:
            print(f"[Engine: {b} Headless] Converting {input_html} -> {output_pdf}...")
            try:
                subprocess.run([
                    cmd_path,
                    "--headless",
                    "--disable-gpu",
                    "--no-sandbox",
                    f"--print-to-pdf={output_pdf}",
                    f"file://{input_html}"
                ], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                if os.path.exists(output_pdf) and os.path.getsize(output_pdf) > 0:
                    print(f"PDF generated successfully via {b}.")
                    return True
            except Exception as e:
                print(f"{b} conversion failed: {e}")

    # Strategy 4: xhtml2pdf
    try:
        from xhtml2pdf import pisa
        print(f"[Engine: xhtml2pdf] Converting {input_html} -> {output_pdf}...")
        with open(input_html, "r", encoding="utf-8") as src, open(output_pdf, "wb") as dst:
            pisa_status = pisa.CreatePDF(src.read(), dest=dst)
        if not pisa_status.err:
            print("PDF generated successfully via xhtml2pdf.")
            return True
    except ImportError:
        pass
    except Exception as e:
        print(f"xhtml2pdf failed: {e}")

    print("Error: No suitable PDF conversion engine found.")
    print("Please install one of: weasyprint, playwright, or google-chrome / chromium.")
    print("Example: pip install weasyprint OR pip install playwright && playwright install chromium")
    return False

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Convert HTML A4 Report to PDF.")
    parser.add_argument("--input", "-i", required=True, help="Input HTML file path")
    parser.add_argument("--output", "-o", required=True, help="Output PDF file path")
    args = parser.parse_args()

    success = convert_html_to_pdf(args.input, args.output)
    sys.exit(0 if success else 1)

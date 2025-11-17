#!/bin/bash
# Monthly documentation cleanup script
# Purpose: Find and organize .md files in root directory
# Created: November 3, 2025 (Documentation Cleanup Initiative)

# ANSI color codes
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
DAYS_OLD=30
ESSENTIAL_FILES=(
    "DOCUMENTATION_HIERARCHY.md"
    "MASTER_DOCUMENTATION_INDEX.md"
    "PHASE_6_COMPLETION_REPORT.md"
    "WEEK3_PHASE1_COMPLETE_HANDOFF.md"
    "AGENTS.md"
    "README_SECRETS.md"
    "REVIEW_TASKS.md"
)

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║          Documentation Cleanup Utility                    ║${NC}"
echo -e "${CYAN}║          Home Assistant Configuration                     ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

cd "$REPO_ROOT" || exit 1

# Function to check if file is essential
is_essential() {
    local file="$1"
    for essential in "${ESSENTIAL_FILES[@]}"; do
        if [ "$file" = "$essential" ]; then
            return 0
        fi
    done
    return 1
}

# Find all .md files in root directory
echo -e "${BLUE}📁 Scanning root directory for .md files...${NC}"
echo ""

total_root_md=$(find . -maxdepth 1 -name "*.md" -type f | wc -l)
echo -e "Total .md files in root: ${YELLOW}$total_root_md${NC}"
echo ""

# Count essential files
essential_count=0
for file in ./*.md; do
    [ -e "$file" ] || continue
    basename_file=$(basename "$file")
    if is_essential "$basename_file"; then
        ((essential_count++))
    fi
done

extra_files=$((total_root_md - essential_count))

echo -e "${GREEN}✓ Essential files: $essential_count${NC}"
echo -e "${YELLOW}⚠ Extra files: $extra_files${NC}"
echo ""

# If no extra files, exit early
if [ "$extra_files" -eq 0 ]; then
    echo -e "${GREEN}✓ Root directory is clean! No cleanup needed.${NC}"
    echo ""
    exit 0
fi

# Find old files (>30 days)
echo -e "${BLUE}🔍 Finding files older than $DAYS_OLD days...${NC}"
echo ""

old_files=()
while IFS= read -r -d '' file; do
    basename_file=$(basename "$file")
    if ! is_essential "$basename_file"; then
        old_files+=("$basename_file")
    fi
done < <(find . -maxdepth 1 -name "*.md" -type f -mtime +"$DAYS_OLD" -print0)

# Find recent extra files
recent_files=()
while IFS= read -r file; do
    [ -e "$file" ] || continue
    basename_file=$(basename "$file")
    if ! is_essential "$basename_file"; then
        # Check if not in old_files
        is_old=false
        for old in "${old_files[@]}"; do
            if [ "$old" = "$basename_file" ]; then
                is_old=true
                break
            fi
        done
        if [ "$is_old" = false ]; then
            recent_files+=("$basename_file")
        fi
    fi
done < <(find . -maxdepth 1 -name "*.md" -type f)

# Display old files
if [ ${#old_files[@]} -gt 0 ]; then
    echo -e "${RED}📅 Old files (>${DAYS_OLD} days):${NC}"
    for file in "${old_files[@]}"; do
        age=$(find . -maxdepth 1 -name "$file" -type f -printf '%TY-%Tm-%Td')
        echo -e "  ${RED}→${NC} $file ${YELLOW}($age)${NC}"
    done
    echo ""
fi

# Display recent extra files
if [ ${#recent_files[@]} -gt 0 ]; then
    echo -e "${YELLOW}📄 Recent extra files (<${DAYS_OLD} days):${NC}"
    for file in "${recent_files[@]}"; do
        age=$(find . -maxdepth 1 -name "$file" -type f -printf '%TY-%Tm-%Td')
        echo -e "  ${YELLOW}→${NC} $file ${CYAN}($age)${NC}"
    done
    echo ""
fi

# Suggest actions
echo -e "${BLUE}💡 Suggested actions:${NC}"
echo ""
echo "1. Review file contents to determine if still needed"
echo "2. Move to appropriate location:"
echo -e "   ${GREEN}•${NC} temp/sessions/       - Temporary session files"
echo -e "   ${GREEN}•${NC} archive/sessions/    - Historical session documentation"
echo -e "   ${GREEN}•${NC} archive/projects/    - Completed project documentation"
echo -e "   ${GREEN}•${NC} archive/phases/      - Phase completion reports"
echo "3. Delete if truly obsolete"
echo ""

# Interactive mode
echo -e "${CYAN}Would you like to interactively organize these files? (y/n)${NC}"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${BLUE}Starting interactive cleanup...${NC}"
    echo ""

    for file in "${old_files[@]}" "${recent_files[@]}"; do
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${YELLOW}File: $file${NC}"
        echo ""
        echo "What would you like to do?"
        echo "  1) Move to temp/sessions/"
        echo "  2) Move to archive/sessions/phase-handoffs/"
        echo "  3) Move to archive/projects/"
        echo "  4) Delete"
        echo "  5) Skip (keep in root)"
        echo ""
        echo -n "Choice (1-5): "
        read -r choice

        case $choice in
            1)
                mkdir -p temp/sessions
                mv "$file" temp/sessions/
                echo -e "${GREEN}✓ Moved to temp/sessions/${NC}"
                ;;
            2)
                mkdir -p archive/sessions/phase-handoffs
                mv "$file" archive/sessions/phase-handoffs/
                echo -e "${GREEN}✓ Moved to archive/sessions/phase-handoffs/${NC}"
                ;;
            3)
                echo "Project name (e.g., yamllint, kiss-optimization): "
                read -r project
                mkdir -p "archive/projects/$project"
                mv "$file" "archive/projects/$project/"
                echo -e "${GREEN}✓ Moved to archive/projects/$project/${NC}"
                ;;
            4)
                echo -e "${RED}Are you sure you want to delete $file? (yes/no)${NC}"
                read -r confirm
                if [ "$confirm" = "yes" ]; then
                    rm "$file"
                    echo -e "${RED}✓ Deleted${NC}"
                else
                    echo -e "${YELLOW}Skipped deletion${NC}"
                fi
                ;;
            5)
                echo -e "${YELLOW}Skipped${NC}"
                ;;
            *)
                echo -e "${RED}Invalid choice, skipping${NC}"
                ;;
        esac
        echo ""
    done

    echo -e "${GREEN}✓ Interactive cleanup complete${NC}"
else
    echo ""
    echo -e "${YELLOW}Manual cleanup required. Organize files as needed.${NC}"
fi

echo ""
echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✓ Cleanup utility complete${NC}"
echo ""
echo "Next steps:"
echo "  • Review and commit any moves: git add -A && git commit"
echo "  • Run this script monthly to keep root directory clean"
echo "  • Set reminder: 1st of each month"
echo ""

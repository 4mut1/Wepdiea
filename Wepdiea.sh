#!/bin/bash

# WEPDIEA (Ana Yönetim Betiği)
# GÜNCELLEME: Proje adi sadece WEPDIEA olarak sadeleştirildi.

# --- Yapılandırma ---
TOOLS_DIR="$HOME/WEPDIEA" # Ana klasor adini WEPDIEA olarak sadeleştirdim

TOOL_URLS=(
    "https://github.com/4lbH4cker/ALHacking.git"           # 1. ALHacking
    "https://github.com/4mut1/4mutddoshackv1.git"          # 2. Kendi DDOS Tool'unuz
    "https://github.com/zeus289x/smsbomber.git"            # 3. SMS Bomber Toolu
    "https://github.com/laramies/theHarvester.git"         # 4. The Harvester (OSINT)
    "https://github.com/robertdavidgraham/masscan.git"     # 5. Masscan (Port Tarama)
    "https://github.com/lanmaster53/recon-ng.git"          # 6. Recon-ng (OSINT)
)
TOOL_NAMES=(
    "ALHacking (Al Hack Toolu)"
    "4muthackddosv1 (Kendi Toolunuz)"
    "SMS Bomber Toolu"
    "The Harvester (OSINT)"
    "Masscan (Hizli Port Tarama)"
    "Recon-ng (Gelistirilmis OSINT)"
)
TOOL_FOLDERS=(
    "ALHacking"
    "Z1RV3HACKDDOSV1"
    "smsbomber"
    "theHarvester"
    "masscan"           
    "recon-ng"          
)

# --- Renkler ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

header() {
    clear
    
    # FIGLET kurulu olmali: sudo apt install figlet
    if command -v figlet &> /dev/null; then
        echo -e "${GREEN}"
        figlet WEPDIEA # <--- SADECE WEPDIEA
        echo -e "${NC}"
    else
        echo -e "${CYAN}==============================================${NC}"
        echo -e "${GREEN}             WEPDIEA - Hos Geldiniz           ${NC}" # <--- SADECE WEPDIEA
    fi

    echo -e "${CYAN}    KLASOR: $TOOLS_DIR                        ${NC}"
    echo -e "${CYAN}==============================================${NC}"
    echo ""
}

check_dependencies() {
    header
    echo -e "${YELLOW}[I] Bagimliliklar Kontrol Ediliyor...${NC}"
    if ! command -v git &> /dev/null
    then
        echo -e "${RED}[HATA] Git kurulu degil. Lutfen kurun: sudo apt install git${NC}"
        exit 1
    fi
    echo -e "${GREEN}[OK] Git kurulu.${NC}"
}

setup_tools() {
    header
    echo -e "${YELLOW}[I] Araclar Kuruluyor/Guncelleniyor...${NC}"
    mkdir -p "$TOOLS_DIR"
    cd "$TOOLS_DIR" || { echo -e "${RED}[HATA] Klasore gidilemedi!${NC}"; exit 1; }

    for i in "${!TOOL_URLS[@]}"; do
        NAME="${TOOL_NAMES[i]}"
        URL="${TOOL_URLS[i]}"
        FOLDER="${TOOL_FOLDERS[i]}"
        echo ""
        echo -e "${CYAN}--- $NAME ($FOLDER) Kontrol Ediliyor...${NC}"

        if [ -d "$FOLDER" ]; then
            echo -e "${YELLOW}[~] $NAME zaten kurulu. Guncelleniyor...${NC}"
            cd "$FOLDER" || { echo -e "${RED}[HATA] $FOLDER klasorune gidilemedi!${NC}"; exit 1; }
            git pull
            cd ..
        else
            echo -e "${GREEN}[+] $NAME klonlaniyor...${NC}"
            git clone "$URL" "$FOLDER"
        fi
    done
    
    # Masscan ve theHarvester icin ÖZEL KURULUM ADIMLARI
    
    # 1. Masscan Derlemesi
    if [ -d "$TOOLS_DIR/masscan" ]; then
        echo -e "${YELLOW}[~] Masscan derleme islemi deneniyor...${NC}"
        cd "$TOOLS_DIR/masscan" || exit 1
        
        echo -e "${YELLOW} Masscan bagimliliklari (gcc, make, libpcap-dev) kuruluyor...${NC}"
        sudo apt update > /dev/null 2>&1
        sudo apt install -y git gcc make libpcap-dev > /dev/null 2>&1
        
        echo -e "${YELLOW} Masscan derleniyor...${NC}"
        make > /dev/null 2>&1
        
        if [ -f "$TOOLS_DIR/masscan/bin/masscan" ]; then
            echo -e "${GREEN}[OK] Masscan basariyla derlendi!${NC}"
            chmod +x bin/masscan
        else
            echo -e "${RED}[HATA] Masscan derlenemedi. Lutfen elle kontrol edin (cd masscan; make).${NC}"
        fi
        cd ..
    fi
    
    # 2. The Harvester Bağımlılıkları
    if [ -d "$TOOLS_DIR/theHarvester" ]; then
        echo -e "${YELLOW}[~] The Harvester Python gereksinimleri kuruluyor...${NC}"
        cd "$TOOLS_DIR/theHarvester" || exit 1
        if [ -f "requirements.txt" ]; then
            pip3 install -r requirements.txt 2>/dev/null || echo -e "${RED}[HATA] theHarvester pip bagimliliklari kurulurken sorun olustu.${NC}"
        fi
        cd ..
    fi
    
    # 3. Recon-ng Bağımlılıkları
    if [ -d "$TOOLS_DIR/recon-ng" ]; then
        echo -e "${YELLOW}[~] Recon-ng Python gereksinimleri kuruluyor...${NC}"
        cd "$TOOLS_DIR/recon-ng" || exit 1
        if [ -f "requirements.txt" ]; then
            pip3 install -r requirements.txt 2>/dev/null || echo -e "${RED}[HATA] Recon-ng pip bagimliliklari kurulurken sorun olustu.${NC}"
        fi
        cd ..
    fi

    echo -e "${GREEN}[OK] Tum araclar kuruldu/guncellendi!${NC}"
    echo ""
    read -p "Devam etmek icin Enter tusuna basin..."
}

run_tool() {
    header
    echo -e "${YELLOW}[?] Lutfen calistirmak istediginiz araci secin:${NC}"
    
    # Menüyü dinamik olarak olustur
    for i in "${!TOOL_NAMES[@]}"; do
        echo -e "  ${GREEN}$((i+1)). ${TOOL_NAMES[i]}${NC}"
    done
    echo -e "  ${RED}0. Cikis${NC}"
    echo ""
    read -p "Seciminiz: " CHOICE
    
    # KESİN CALISTIRMA KOMUTLARI BURADA!
    case $CHOICE in
        1) TOOL_TO_RUN="ALHacking"; ENTRY_POINT="alhack.sh"; RUN_COMMAND="bash";;
        2) TOOL_TO_RUN="Z1RV3HACKDDOSV1"; ENTRY_POINT="1RV3HACKDDOSV1"; RUN_COMMAND="python3";;
        3) TOOL_TO_RUN="smsbomber"; ENTRY_POINT="smsbomber.py"; RUN_COMMAND="python";;
        
        # OSINT TOOL KOMUTLARI
        4) TOOL_TO_RUN="theHarvester"; ENTRY_POINT="theHarvester.py"; RUN_COMMAND="python3";; 
        5) TOOL_TO_RUN="masscan"; ENTRY_POINT="bin/masscan"; RUN_COMMAND="sudo";;
        6) TOOL_TO_RUN="recon-ng"; ENTRY_POINT="recon-ng"; RUN_COMMAND="./";; 
        
        0) echo -e "${CYAN}[X] WEPDIEA'dan cikiliyor. Gule gule!${NC}"; exit 0;; # <--- SADECE WEPDIEA
        *) echo -e "${RED}[HATA] Gecersiz secim. Lutfen tekrar deneyin.${NC}"; sleep 2; return;;
    esac
    
    # Arac calistirma mantigi
    if [ -f "$TOOLS_DIR/$TOOL_TO_RUN/$ENTRY_POINT" ]; then
        header
        echo -e "${CYAN}--- ${TOOL_NAMES[CHOICE-1]} Araci Baslatiliyor (${RUN_COMMAND} ${ENTRY_POINT})...${NC}"
        cd "$TOOLS_DIR/$TOOL_TO_RUN" || { echo -e "${RED}[HATA] Klasore gidilemedi!${NC}"; sleep 3; return; }
        
        chmod +x "$ENTRY_POINT" 2>/dev/null || true
        
        if [ "$RUN_COMMAND" == "python3" ] || [ "$RUN_COMMAND" == "python" ]; then
            $RUN_COMMAND "$ENTRY_POINT"
        elif [ "$RUN_COMMAND" == "bash" ]; then
            bash "$ENTRY_POINT"
        elif [ "$RUN_COMMAND" == "sudo" ]; then
            # Masscan calistirma: Tam yolu kullan
            sudo "$TOOLS_DIR/$TOOL_TO_RUN/$ENTRY_POINT" 
        elif [ "$RUN_COMMAND" == "./" ]; then
            ./"$ENTRY_POINT"
        fi

        echo ""
        read -p "Aracin calismasi bitti. Menuye donmek icin Enter tusuna basin..."
    else
        echo -e "${RED}[HATA] Calistirilabilir dosya bulunamadi: $ENTRY_POINT${NC}"
        echo -e "${YELLOW}[~] Lutfen $TOOLS_DIR/$TOOL_TO_RUN klasorunu kontrol edin ve betigi dogru dosya adiyla guncelleyin.${NC}"
        sleep 3
    fi
}

# --- Ana Menu ---
main_menu() {
    while true; do
        header
        echo -e "${YELLOW}[?] Yapmak istediginiz islemi secin:${NC}"
        echo -e "  ${GREEN}1. Kurulum / Araclari Guncelle${NC}"
        echo -e "  ${GREEN}2. Araclari Calistir${NC}"
        echo -e "  ${RED}0. Cikis${NC}"
        echo ""
        read -p "Seciminiz: " MAIN_CHOICE
        
        case $MAIN_CHOICE in
            1) setup_tools;;
            2) run_tool;;
            0) echo -e "${CYAN}[X] WEPDIEA'dan cikiliyor. Gule gule!${NC}"; exit 0;;
            *) echo -e "${RED}[HATA] Gecersiz secim. Lutfen tekrar deneyin.${NC}"; sleep 2;;
        esac
    done
}

# --- Baslangic ---
check_dependencies
main_menu
#!/bin/bash
# ============================================
# FunS World - Git 히스토리 완전 초기화 스크립트
# 모든 커밋 기록의 개인정보를 제거합니다
# ============================================

echo "🔒 funs-world 리포 히스토리 초기화 시작..."

# 1. 임시 디렉토리 생성
TEMP_DIR=$(mktemp -d)
echo "📁 임시 디렉토리: $TEMP_DIR"

# 2. funs-world 리포가 있는지 확인
if [ ! -d ~/funs-world/.git ]; then
    echo "❌ ~/funs-world 리포를 찾을 수 없습니다."
    exit 1
fi

# 3. Funshome에서 파일 복사 (CLAUDE.md와 .git 제외)
echo "📋 Funshome에서 클린 파일 복사 중..."
cd "$TEMP_DIR"
git init
git branch -m main

# Funshome에서 모든 파일 복사
rsync -av --exclude='.git' --exclude='CLAUDE.md' --exclude='WALLET_BUILD_PROMPT.md' ~/FUNS/Funshome/ . > /dev/null 2>&1

# 4. CNAME 파일 생성 (GitHub Pages 커스텀 도메인용)
echo "funs.world" > CNAME

# 5. 개인정보 없는 클린 커밋 생성
git add -A
git -c user.name="FunS Team" -c user.email="team@funs.world" commit -m "Initial release - FunS Web3 Gaming Platform

Complete website with wallet, DEX, games, marketplace, NFT gallery,
and multi-language support (KO/EN)."

echo ""
echo "✅ 클린 커밋 생성 완료!"
git log --format="%h %an <%ae> %s" -1
echo ""

# 6. funs-world 리모트 추가 및 force push
git remote add origin https://github.com/tololalo/funs-world.git
echo "🚀 funs-world에 force push 중..."
git push --force origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ funs-world 히스토리 초기화 완료!"
    echo "   - 모든 이전 커밋 기록 삭제됨"
    echo "   - 커밋 저자: FunS Team <team@funs.world>"
    echo "   - CNAME: funs.world"

    # 7. ~/funs-world 로컬 리포도 업데이트
    echo ""
    echo "📦 로컬 funs-world 리포 업데이트 중..."
    cd ~/funs-world
    git fetch origin
    git reset --hard origin/main
    echo "✅ 로컬 리포도 동기화 완료!"
else
    echo "❌ push 실패. GitHub 인증을 확인해주세요."
fi

# 8. 임시 디렉토리 정리
rm -rf "$TEMP_DIR"
echo ""
echo "🧹 임시 파일 정리 완료"

# ============================================
# funs-platform도 초기화 (선택사항)
# ============================================
echo ""
read -p "funs-platform도 동일하게 히스토리를 초기화할까요? (y/n): " answer
if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    TEMP_DIR2=$(mktemp -d)
    cd "$TEMP_DIR2"
    git init
    git branch -m main

    rsync -av --exclude='.git' --exclude='CLAUDE.md' --exclude='WALLET_BUILD_PROMPT.md' ~/FUNS/Funshome/ . > /dev/null 2>&1

    git add -A
    git -c user.name="FunS Team" -c user.email="team@funs.world" commit -m "Initial release - FunS Web3 Gaming Platform

Complete website with wallet, DEX, games, marketplace, NFT gallery,
and multi-language support (KO/EN)."

    git remote add origin https://tololalo@github.com/tololalo/funs-platform.git
    echo "🚀 funs-platform에 force push 중..."
    git push --force origin main

    if [ $? -eq 0 ]; then
        echo "✅ funs-platform 히스토리 초기화 완료!"
        cd ~/FUNS/Funshome
        git fetch origin
        git reset --hard origin/main
    else
        echo "❌ funs-platform push 실패"
    fi

    rm -rf "$TEMP_DIR2"
fi

echo ""
echo "🎉 모든 작업 완료!"

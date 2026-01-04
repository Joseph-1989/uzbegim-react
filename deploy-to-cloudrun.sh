#!/bin/bash

# Uzbegim React - Google Cloud Run Deployment Script
# This script provides a guided manual deployment process

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ID="optical-habitat-478204-p3"
REGION="europe-west1"
SERVICE_NAME="uzbegim-react"
BACKEND_URL="https://uzbegim-416311469862.europe-west1.run.app"

echo -e "${BLUE}==================================================${NC}"
echo -e "${BLUE}  Uzbegim React - Cloud Run Deployment${NC}"
echo -e "${BLUE}==================================================${NC}"
echo ""

# Step 1: Check prerequisites
echo -e "${YELLOW}Step 1: Checking prerequisites...${NC}"
echo ""

# Check gcloud
if ! command -v gcloud &> /dev/null; then
    echo -e "${RED}✗ gcloud CLI is not installed${NC}"
    echo "Please install from: https://cloud.google.com/sdk/docs/install"
    exit 1
fi
echo -e "${GREEN}✓ gcloud CLI is installed${NC}"

# Check Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}✗ Docker is not installed${NC}"
    echo "Please install from: https://www.docker.com/products/docker-desktop"
    exit 1
fi
echo -e "${GREEN}✓ Docker is installed${NC}"

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo -e "${RED}✗ Docker is not running${NC}"
    echo "Please start Docker Desktop"
    exit 1
fi
echo -e "${GREEN}✓ Docker is running${NC}"

echo ""
echo -e "${YELLOW}Step 2: Setting up Google Cloud configuration...${NC}"
echo ""

# Set project
echo "Setting project to: $PROJECT_ID"
gcloud config set project $PROJECT_ID

# Authenticate
echo ""
echo -e "${BLUE}Please ensure you are authenticated with Google Cloud.${NC}"
read -p "Have you run 'gcloud auth login'? (y/n): " auth_confirmed
if [[ $auth_confirmed != "y" ]]; then
    echo "Please run: gcloud auth login"
    exit 1
fi

# Enable APIs
echo ""
echo -e "${YELLOW}Step 3: Enabling required APIs...${NC}"
echo ""
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable containerregistry.googleapis.com
gcloud services enable artifactregistry.googleapis.com
echo -e "${GREEN}✓ APIs enabled${NC}"

# Configure Docker
echo ""
echo -e "${YELLOW}Step 4: Configuring Docker authentication...${NC}"
echo ""
gcloud auth configure-docker
echo -e "${GREEN}✓ Docker configured${NC}"

# Ask about API URL
echo ""
echo -e "${YELLOW}Step 5: Configure API URL${NC}"
echo ""
echo "Default backend URL: $BACKEND_URL"
read -p "Use this URL? (y/n): " use_default_url

if [[ $use_default_url != "y" ]]; then
    read -p "Enter your backend URL: " BACKEND_URL
fi

# Build Docker image
echo ""
echo -e "${YELLOW}Step 6: Building Docker image...${NC}"
echo ""
read -p "Enter version tag (e.g., v1.0.0): " VERSION_TAG

IMAGE_NAME="gcr.io/$PROJECT_ID/$SERVICE_NAME"

echo "Building image: $IMAGE_NAME:$VERSION_TAG"
echo "API URL: $BACKEND_URL"

docker build \
  --platform linux/amd64 \
  --build-arg REACT_APP_API_URL=$BACKEND_URL \
  -t $IMAGE_NAME:$VERSION_TAG \
  -t $IMAGE_NAME:latest \
  .

echo -e "${GREEN}✓ Docker image built successfully${NC}"

# Test locally (optional)
echo ""
read -p "Would you like to test the image locally first? (y/n): " test_locally

if [[ $test_locally == "y" ]]; then
    echo ""
    echo -e "${BLUE}Starting container on http://localhost:8080${NC}"
    echo -e "${BLUE}Press Ctrl+C to stop and continue with deployment${NC}"
    echo ""
    docker run -p 8080:8080 $IMAGE_NAME:$VERSION_TAG
fi

# Push to GCR
echo ""
echo -e "${YELLOW}Step 7: Pushing image to Google Container Registry...${NC}"
echo ""
docker push $IMAGE_NAME:$VERSION_TAG
docker push $IMAGE_NAME:latest
echo -e "${GREEN}✓ Image pushed successfully${NC}"

# Deploy to Cloud Run
echo ""
echo -e "${YELLOW}Step 8: Deploying to Cloud Run...${NC}"
echo ""

gcloud run deploy $SERVICE_NAME \
  --image $IMAGE_NAME:$VERSION_TAG \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated \
  --port 8080 \
  --memory 512Mi \
  --cpu 1 \
  --max-instances 10 \
  --min-instances 0

echo ""
echo -e "${GREEN}==================================================${NC}"
echo -e "${GREEN}  ✓ Deployment completed successfully!${NC}"
echo -e "${GREEN}==================================================${NC}"
echo ""

# Get service URL
SERVICE_URL=$(gcloud run services describe $SERVICE_NAME --region $REGION --format='value(status.url)')
echo -e "${BLUE}Service URL: ${SERVICE_URL}${NC}"
echo ""

echo -e "${YELLOW}Next steps:${NC}"
echo "1. Open the service URL in your browser"
echo "2. Test all functionality"
echo "3. Check logs: gcloud run services logs read $SERVICE_NAME --region $REGION"
echo ""

read -p "Would you like to open the service URL now? (y/n): " open_url
if [[ $open_url == "y" ]]; then
    open $SERVICE_URL
fi

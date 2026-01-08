export const serverApi: string = `${process.env.REACT_APP_API_URL}`;

/**
 * Helper function to construct image URLs.
 * Returns the URL as-is if it's already a full URL (GCS),
 * otherwise prepends serverApi for relative paths.
 */
export const getImageUrl = (imagePath: string | undefined): string => {
  if (!imagePath) return "";

  // Check if the path is already a full URL (starts with http:// or https://)
  if (imagePath.startsWith("http://") || imagePath.startsWith("https://")) {
    return imagePath;
  }

  // For relative paths, prepend serverApi
  return `${serverApi}/${imagePath}`;
};

export const Messages = {
  error1: "Something went wrong!",
  error2: "Please login first!",
  error3: "Please fulfill all inputs!",
  error4: "Message is empty!",
  error5: "Only images with jpeg, jpg, png format allowed!",
};

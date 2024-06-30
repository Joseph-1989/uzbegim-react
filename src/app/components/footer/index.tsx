import React from "react";
import { Box, Container, Stack } from "@mui/material";
import { Link } from "react-router-dom";
import styled from "styled-components";

const Footers = styled.div`
  width: 100%;
  height: 100%;
  display: flex;
  background: #767d6e;
  background-size: cover;
`;

export default function Footer() {
  const authMember = null;

  return (
    <Footers>
      <Container>
        <Stack flexDirection={"row"} sx={{ mt: "94px" }}>
          <Box>
            <img width={"150px"} src={"/icons/uzbegim-halal-logo.png"} alt="" />
          </Box>
          <Stack flexDirection={"column"} style={{ width: "400px" }}>
            <Box className={"foot-desc-txt"}>
              <Box className={"restaurant-description"}>
                UZBEGIM – A TASTE OF UZBEKISTAN IN SEOUL
              </Box>
              UZBEGIM, meaning "My Uzbek," brings the vibrant flavors and rich
              culture of Uzbekistan to Seoul. Our passionate team crafts a
              unique dining experience, inviting you on a culinary journey
              through authentic dishes celebrating our heritage. Uzbek cuisine
              boasts a captivating history, renowned for its diverse flavors and
              aromatic spices, influenced by neighboring countries. At UZBEGIM,
              we share these stories and traditions, capturing the essence of
              Uzbek culinary culture. Experience the warmth of Uzbek hospitality
              and unforgettable tastes of Uzbekistan right here in Seoul. We
              can't wait to welcome you!
            </Box>
            <Box className="sns-context">
              <img src={"/icons/facebook.svg"} alt="" />
              <img src={"/icons/twitter.svg"} alt="" />
              <img src={"/icons/instagram.svg"} alt="" />
              <img src={"/icons/youtube.svg"} alt="" />
            </Box>
          </Stack>
          <Stack sx={{ ml: "290px" }} flexDirection={"row"}>
            <Stack>
              <Box>
                <Box className={"foot-category-title"}>Sections</Box>
                <Box className={"foot-category-link"}>
                  <Link to="/">Home</Link>
                  <Link to="/products">Products</Link>
                  {authMember && <Link to="/orders">Orders</Link>}
                  <Link to="/help">Help</Link>
                </Box>
              </Box>
            </Stack>
            <Stack sx={{ ml: "100px" }}>
              <Box>
                <Box className={"foot-category-title"}>Find us</Box>
                <Box
                  flexDirection={"column"}
                  sx={{ mt: "20px" }}
                  className={"foot-category-link"}
                  justifyContent={"space-between"}
                >
                  <Box flexDirection={"row"} className={"find-us"}>
                    <span>L.</span>
                    <div>Seoul, South Korea</div>
                  </Box>
                  <Box className={"find-us"}>
                    <span>P.</span>
                    <div>+82 10 4444 7777</div>
                  </Box>
                  <Box className={"find-us"}>
                    <span>E.</span>
                    <div>uzbegim-uz@gmail.com</div>
                  </Box>
                  <Box className={"find-us"}>
                    <span>H.</span>
                    <div>Visit 24 hours</div>
                  </Box>
                </Box>
              </Box>
            </Stack>
          </Stack>
        </Stack>
        <Stack
          style={{ border: "1px solid #C5C8C9", width: "100%", opacity: "0.2" }}
          sx={{ mt: "30px" }}
        ></Stack>
        <Stack className={"copyright-txt"}>
          © Copyright Uzbegim Global, All rights reserved.
        </Stack>
      </Container>
    </Footers>
  );
}

// tailwind.config.js
module.exports = {
  content: [
    "./pages/**/*.{ts,tsx,vue}",
    "./components/**/*.{ts,tsx,vue}",
    "./app/**/*.{ts,tsx,vue}",
    "./src/**/*.{ts,tsx,vue}",
  ],
  theme: {
    extend: {
      colors: {
        main: "rgba(102, 122, 221, 1)",
        secondary: "C6CEF1",
      },
    },
  },
  variants: {},
  plugins: [],
};

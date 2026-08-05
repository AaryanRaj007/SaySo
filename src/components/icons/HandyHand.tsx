const HandyHand = ({
  width,
  height,
}: {
  width?: number | string;
  height?: number | string;
}) => {
  // Scale font size proportionally
  const numWidth = typeof width === "string" ? parseInt(width, 10) : width || 24;
  const fontSize = numWidth * 0.85;

  return (
    <span
      style={{
        display: "inline-flex",
        alignItems: "center",
        justifyContent: "center",
        width: width || 24,
        height: height || 24,
        fontFamily: '"Bagel Fat One", cursive, sans-serif',
        fontSize: `${fontSize}px`,
        color: "var(--color-logo-primary)",
        WebkitTextStroke: "1px var(--color-logo-stroke)",
        paintOrder: "stroke fill",
        lineHeight: 1,
        userSelect: "none",
      }}
    >
      S
    </span>
  );
};

export default HandyHand;

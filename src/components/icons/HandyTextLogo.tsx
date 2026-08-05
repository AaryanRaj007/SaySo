import React from "react";

const HandyTextLogo = ({
  width,
  height,
  className,
}: {
  width?: number;
  height?: number;
  className?: string;
}) => {
  // Scale font size proportionally to width
  const baseWidth = 200;
  const baseFontSize = 48;
  const effectiveWidth = width || baseWidth;
  const scale = effectiveWidth / baseWidth;
  const fontSize = baseFontSize * scale;

  return (
    <div
      className={`brand-logo ${className || ""}`}
      style={{
        width: width,
        height: height,
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        userSelect: "none",
        lineHeight: 1,
      }}
    >
      <span
        style={{
          fontFamily: '"Bagel Fat One", cursive, sans-serif',
          fontSize: `${fontSize}px`,
          color: "var(--color-logo-primary)",
          WebkitTextStroke: `${1.5 * scale}px var(--color-logo-stroke)`,
          paintOrder: "stroke fill",
          letterSpacing: `${-1 * scale}px`,
        }}
      >
        SaySo
      </span>
    </div>
  );
};

export default HandyTextLogo;

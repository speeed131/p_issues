import { fn } from "storybook/test";
import { Square } from "../Square";

const meta = {
  title: "Square",
  component: Square,
  parameters: {
    layout: "centered",
  },
  tags: ["autodocs"],
  argTypes: {
    value: {
      control: { type: "select" },
      options: ["X", "O", null],
      description: "マスの表示値",
    },
    onSquareClick: {
      action: "onSquareClick",
      description: "クリック時のコールバック",
    },
  },
  args: {
    value: null,
    onSquareClick: fn(),
  },
};

export default meta;

export const Empty = {
  args: { value: null },
};

export const X = {
  args: { value: "X" },
};

export const O = {
  args: { value: "O" },
};

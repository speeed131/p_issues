import { fn } from "storybook/test";
import { Board } from "../Board";

const empty9 = Array(9).fill(null);

const meta = {
  title: "Molecules/Board",
  component: Board,
  parameters: {
    layout: "centered",
  },
  tags: ["autodocs"],
  argTypes: {
    xIsNext: {
      control: "boolean",
      description: "次の手番がXかどうか",
    },
    squares: {
      description: "盤面の配列（長さ9）",
      control: false,
    },
    onPlay: {
      action: "onPlay",
      description: "次の盤面が確定したときに呼ばれる",
    },
  },
  args: {
    xIsNext: true,
    squares: empty9,
    onPlay: fn(),
  },
};

export default meta;

export const Empty = {};

export const MidGame = {
  args: {
    xIsNext: true,
    squares: ["X", null, "O", null, "X", null, null, "O", null],
  },
};

export const XWins = {
  args: {
    xIsNext: false,
    squares: ["X", "X", "X", null, null, null, null, null, null],
  },
};

export const OWins = {
  args: {
    xIsNext: true,
    squares: ["O", null, "X", "O", "X", null, "O", null, null],
  },
};

export const Triangles = {
  args: {
    xIsNext: true,
    squares: ["△", "△", "△", "△", "△", "△", "△", "△", "△"],
  },
};

import { Game } from "../Game";
import { expect } from "storybook/test";

const meta = {
  title: "Game",
  component: Game,
  parameters: { layout: "centered" },
  tags: ["autodocs"],
};
export default meta;

export const Default = {};

export const XWinsByTopRow = {
  play: async ({ canvas, userEvent }) => {
    // 初期の手番表示を待つ
    await canvas.findByText(/Next player:\s*X/);

    // 盤面の9マスを取得
    const squares = await canvas.findAllByRole("button", { name: "" });
    if (squares.length !== 9)
      throw new Error("squares not found or length !== 9");

    // クリック順: X:0, O:3, X:1, O:4, X:2
    await userEvent.click(squares[0]); // X
    await userEvent.click(squares[3]); // O
    await userEvent.click(squares[1]); // X
    await userEvent.click(squares[4]); // O
    await userEvent.click(squares[2]); // X → 勝利

    // 勝利メッセージを確認
    await expect(canvas.getByText(/Winner:\s*X/)).toBeInTheDocument();
  },
};

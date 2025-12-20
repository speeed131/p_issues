import { describe, expect, it } from "vitest";
import { multiply, add, subtract, divide } from "./issue2";

describe("Issue 2", () => {
  describe("multiply", () => {
    it("should return 90 when multiplying 3, 10, and 3", () => {
      expect(multiply(3, 10, 3)).to.equal(90);
    });
    // １個の引数を受け取る
    it("should handle a single argument", () => {
      expect(multiply(5)).to.equal(5);
    });

    // 30個の引数を受け取る
    it("should handle up to 30 arguments", () => {
      const args = Array.from({ length: 30 }, () => 1); // 30個の1を用意
      expect(multiply(...args)).to.equal(1);
    });
    // 31個以上の引数を受け取るとエラーを返す
    it("should throw an error when more than 30 arguments are provided", () => {
      const args = Array.from({ length: 31 }, () => 2); // 31個の2を用意
      expect(() => multiply(...args)).toThrow("Too many arguments");
    });

    it("should throw when a non-numeric argument is provided", () => {
      const nonNumeric = "a" as unknown as number;
      expect(() => multiply(2, nonNumeric)).toThrow("Invalid argument");
    });

    it("should return 'big big number' when product exceeds 1000", () => {
      expect(multiply(20, 60)).to.equal("big big number");
    });
  });

  describe("add", () => {
    it("should return 16 when adding 3, 10, and 3", () => {
      expect(add(3, 10, 3)).to.equal(16);
    });
    // １個の引数を受け取る
    it("should handle a single argument", () => {
      expect(add(5)).to.equal(5);
    });

    // 30個の引数を受け取る
    it("should handle up to 30 arguments", () => {
      const args = Array.from({ length: 30 }, () => 2); // 30個の2を用意
      expect(add(...args)).to.equal(60);
    });
    // 31個以上の引数を受け取るとエラーを返す
    it("should throw an error when more than 30 arguments are provided", () => {
      const args = Array.from({ length: 31 }, () => 2); // 31個の2を用意
      expect(() => add(...args)).toThrow("Too many arguments");
    });

    it("should throw when a non-numeric argument is provided", () => {
      const nonNumeric = "a" as unknown as number;
      expect(() => add(2, nonNumeric)).toThrow("Invalid argument");
    });

    it("should return 'too big' when sum exceeds 1000", () => {
      expect(add(600, 401)).to.equal("too big");
    });
  });

  describe("subtract", () => {
    it("should return the difference when result stays non-negative", () => {
      expect(subtract(10, 3, 3)).to.equal(4);
    });

    // １個の引数を受け取る
    it("should handle a single argument", () => {
      expect(subtract(5)).to.equal(5);
    });
    // 30個の引数を受け取る
    it("should handle up to 30 arguments", () => {
      const args = [
        150,
        ...Array.from({ length: 29 }, () => 1),
      ];
      expect(subtract(...args)).to.equal(121);
    });
    // 31個以上の引数を受け取るとエラーを返す
    it("should throw an error when more than 30 arguments are provided", () => {
      const args = Array.from({ length: 31 }, () => 1); // 31個の1を用意
      expect(() => subtract(...args)).toThrow("Too many arguments");
    });

    it("should throw when a non-numeric argument is provided", () => {
      const nonNumeric = "a" as unknown as number;
      expect(() => subtract(2, nonNumeric)).toThrow("Invalid argument");
    });

    it("should return 'negative number' when result is negative", () => {
      expect(subtract(3, 4)).to.equal("negative number");
    });
  });

  describe("divide", () => {
    it("should return 10 when dividing 100 by 10", () => {
      expect(divide(100, 10)).to.equal(10);
    });
    // １個の引数を受け取る
    it("should handle a single argument", () => {
      expect(divide(5)).to.equal(5);
    });

    // 30個の引数を受け取る
    it("should handle up to 30 arguments", () => {
      const args = Array.from({ length: 30 }, () => 1); // 30個の1を用意（意図は30個受け取れることの確認）
      expect(divide(...args)).to.equal(1);
    });
    // 31個以上の引数を受け取るとエラーを返す
    it("should throw an error when more than 30 arguments are provided", () => {
      const args = Array.from({ length: 31 }, () => 2); // 31個の2を用意
      expect(() => divide(...args)).toThrow("Too many arguments");
    });

    it("should throw when a non-numeric argument is provided", () => {
      const nonNumeric = "a" as unknown as number;
      expect(() => divide(2, nonNumeric)).toThrow("Invalid argument");
    });

    it("should round the result to two decimal places", () => {
      expect(divide(1, 3)).to.equal(0.33);
    });

    it("should round down when the third decimal is less than 5", () => {
      expect(divide(1, 250)).to.equal(0);
    });

    it("should round up when the third decimal is 5 or more", () => {
      expect(divide(1, 200)).to.equal(0.01);
    });
  });
});

# DDD 課題2

## 課題2-1

> 境界づけられたコンテキストの実例を一つ挙げてください。

注文としての「Order」を扱う際に、同じstatusの状態を扱うプロパティだとしても、ユーザとの購入契約を意味する（paid, canceld, refundedなど）か、配送業者との出荷指示として意味するか（picking, packed, shipped）など

## 課題2-2

> 以下のプロパティを持つ「Human」エンティティを作成してください。

```ts

export class HumanId {
  private static readonly PATTERN = /^[a-zA-Z0-9]+$/;

  private constructor(public readonly value: string) {}

  static fromString(value: string): HumanId {
    const v = value.trim();
    if (v.length === 0) throw new Error("HumanIdは空にできません。");
    if (!HumanId.PATTERN.test(v)) {
      throw new Error("HumanIdは英数字のみ使用できます。");
    }
    return new HumanId(v);
  }

  static generate(): HumanId {
    const random =
      globalThis.crypto?.randomUUID?.().replace(/-/g, "") ??
      `${Date.now().toString(36)}${Math.random().toString(36).slice(2)}`;
    return HumanId.fromString(random);
  }
}

export type ABO = "a" | "b" | "o" | "ab";

export class BloodType {
  private static readonly ALLOWED = new Set<ABO>(["a", "b", "o", "ab"]);

  private constructor(public readonly value: ABO) {}

  static of(value: string): BloodType {
    const v = value.trim().toLowerCase() as ABO;
    if (!BloodType.ALLOWED.has(v)) {
      throw new Error("血液型は a, b, o, ab のいずれかを指定してください。");
    }
    return new BloodType(v);
  }

  toString(): string {
    return this.value;
  }
}

export class BirthDate {
  private readonly _value: Date;

  private constructor(value: Date) {
    this._value = new Date(value.getTime());
  }

  get value(): Date {
    return new Date(this._value.getTime());
  }

  static fromDate(date: Date): BirthDate {
    const d = new Date(date);
    d.setHours(0, 0, 0, 0);

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    if (Number.isNaN(d.getTime())) throw new Error("生年月日が不正です。");
    if (d > today) throw new Error("生年月日は未来日にできません。");
    if (BirthDate.calculateAge(d, today) < 20) {
      throw new Error("生年月日は20歳以上になる日付を指定してください。");
    }

    return new BirthDate(d);
  }

}

export class HumanName {
  private constructor(public readonly value: string) {}

  static fromString(value: string): HumanName {
    const v = value.trim();
    if (v.length === 0) throw new Error("名前は空にできません。");
    const length = Array.from(v).length;
    if (length >= 20) throw new Error("名前は20文字未満で入力してください。");
    return new HumanName(v);
  }
}

// --------- Entity ---------

export class Human {
  private constructor(
    public readonly id: HumanId,
    private _bloodType: BloodType,
    private _birthDate: BirthDate,
    private _name: HumanName
  ) {}

  static create(params: {
    id?: HumanId;
    bloodType: BloodType;
    birthDate: BirthDate;
    name: HumanName;
  }): Human {
    return new Human(
      params.id ?? HumanId.generate(),
      params.bloodType,
      params.birthDate,
      params.name
    );
  }

  get bloodType(): BloodType {
    return this._bloodType;
  }

  get birthDate(): BirthDate {
    return this._birthDate;
  }

  get name(): HumanName {
    return this._name;
  }


  equals(other: Human): boolean {
    return this.id.value === other.id.value;
  }
}
```

```ts
// 生成

const human = Human.create({
  bloodType: BloodType.of("o"),
  birthDate: BirthDate.fromDate(new Date("1995-03-01")),
  name: HumanName.fromString("山田太郎"),
});
```

## 課題2-3

- 値に意味や制約があるのに `string` や `Date` の生データで扱っているところ
  - 不正値を作れてしまう
  - 検証ロジックが散らばる
    - どこでバリデーションするか統一されず、重複や漏れが起きやすい。
  - 型だけでは意味が伝わらない
  - 不変条件をモデルで守れない

## 課題2-4

課題2-2にて記述

# DDD 課題3

> よくDDDの文脈で会話していると「ドメイン知識が漏れている」という表現を目にすることがあります。これは一体どういう意味なのか説明するため、ドメイン知識が漏れているサンプルコードを作成してください。

「ドメイン知識が漏れている」とは、本来ドメイン層に置くべき業務ルールが、ControllerやRepositoryなど他の層に散らばっている状態のこと。

```ts
// OrderController.ts
// ドメイン知識が APIのController に漏れている例

import { Request, Response } from "express";
import { db } from "./db";

export async function cancelOrder(req: Request, res: Response): Promise<void> {
  const orderId = req.params.orderId;
  const userId = req.user.id;

  const order = await db.order.findUnique({ where: { id: orderId } });
  if (!order) {
    res.status(404).json({ message: "注文が見つかりません" });
    return;
  }

  // ドメインルール: 他人の注文はキャンセル不可
  // cancelBy などでドメイン層に入れる
  if (order.userId !== userId) {
    res.status(403).json({ message: "他人の注文はキャンセルできません" });
    return;
  }

  // ドメインルール: 出荷済みはキャンセル不可
  // cancelBy などでドメイン層に入れる
  if (order.shippingStatus === "shipped") {
    res.status(400).json({ message: "出荷済みの注文はキャンセルできません" });
    return;
  }

  await db.order.update({
    where: { id: orderId },
    data: {
      status: "canceled",
      canceledAt: new Date(),
    },
  });

  res.status(200).json({ message: "キャンセルしました" });
}
```

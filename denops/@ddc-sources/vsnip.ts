import {
  BaseSource,
  Item,
} from "https://deno.land/x/ddc_vim@v3.1.0/types.ts#^";
import { Denops, fn } from "https://deno.land/x/ddc_vim@v3.1.0/deps.ts#^";

type Params = Record<string, never>;

export class Source extends BaseSource<Params> {
  async gather(args: {
    denops: Denops;
  }): Promise<Item[]> {
    return args.denops.call(
      "vsnip#get_complete_items",
      await fn.bufnr(args.denops),
    ) as Promise<Item[]>;
  }

  params(): Params {
    return {};
  }
}

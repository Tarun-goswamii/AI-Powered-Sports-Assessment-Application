/* eslint-disable */
/**
 * Generated `api` utility.
 *
 * THIS CODE IS AUTOMATICALLY GENERATED.
 *
 * To regenerate, run `npx convex dev`.
 * @module
 */

import type {
  ApiFromModules,
  FilterApi,
  FunctionReference,
} from "convex/server";
import type * as auth from "../auth.js";
import type * as community from "../community.js";
import type * as creditPoints from "../creditPoints.js";
import type * as functions from "../functions.js";
import type * as functions_additional from "../functions_additional.js";
import type * as seed_data from "../seed_data.js";
import type * as testResults from "../testResults.js";
import type * as tests from "../tests.js";
import type * as users from "../users.js";

/**
 * A utility for referencing Convex functions in your app's API.
 *
 * Usage:
 * ```js
 * const myFunctionReference = api.myModule.myFunction;
 * ```
 */
declare const fullApi: ApiFromModules<{
  auth: typeof auth;
  community: typeof community;
  creditPoints: typeof creditPoints;
  functions: typeof functions;
  functions_additional: typeof functions_additional;
  seed_data: typeof seed_data;
  testResults: typeof testResults;
  tests: typeof tests;
  users: typeof users;
}>;
export declare const api: FilterApi<
  typeof fullApi,
  FunctionReference<any, "public">
>;
export declare const internal: FilterApi<
  typeof fullApi,
  FunctionReference<any, "internal">
>;

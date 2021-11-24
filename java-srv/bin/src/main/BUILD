load("@io_bazel_rules_kotlin//kotlin:kotlin.bzl", "kt_jvm_binary")

kt_jvm_binary (
    name = "BazelApp",
    srcs = glob(["kotlin/**/*.kt"]),
    main_class = "example.AppKt",
    deps = [
      "@maven//:org_mongodb_mongo_java_driver",
    ],
)

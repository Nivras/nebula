/* Copyright (c) 2021 vesoft inc. All rights reserved.
 *
 * This source code is licensed under Apache 2.0 License.
 */
#pragma once
#include "storage/exec/IndexNode.h"

namespace nebula {
namespace storage {

class IndexAggregateNode : public IndexNode {
 public:
  IndexAggregateNode(const IndexAggregateNode& node);
  explicit IndexAggregateNode(RuntimeContext* context);

  std::unique_ptr<IndexNode> copy() override;
  std::string identify() override;

 private:
  nebula::cpp2::ErrorCode doExecute(PartitionID partId) override;
  Result doNext() override;
};

}  // namespace storage
}  // namespace nebula

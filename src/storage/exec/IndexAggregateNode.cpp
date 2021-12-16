/* Copyright (c) 2021 vesoft inc. All rights reserved.
 *
 * This source code is licensed under Apache 2.0 License.
 */

#include "storage/exec/IndexAggregateNode.h"

namespace nebula {
namespace storage {

IndexAggregateNode::IndexAggregateNode(const IndexAggregateNode& node) : IndexNode(node) {}

IndexAggregateNode::IndexAggregateNode(RuntimeContext* context)
    : IndexNode(context, "IndexAggregateNode") {}

nebula::cpp2::ErrorCode IndexAggregateNode::doExecute(PartitionID partId) {
  UNUSED(partId);
  return nebula::cpp2::ErrorCode::SUCCEEDED;
}

IndexNode::Result IndexAggregateNode::doNext() { return Result(); }

std::unique_ptr<IndexNode> IndexAggregateNode::copy() {
  return std::make_unique<IndexAggregateNode>(*this);
}

std::string IndexAggregateNode::identify() { return ""; }

}  // namespace storage

}  // namespace nebula

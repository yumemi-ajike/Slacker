//
//  ChannelsViewController.swift
//  Slacker
//
//  Created by 寺家 篤史 on 2018/07/19.
//  Copyright © 2018年 Atsushi Jike. All rights reserved.
//

import UIKit

class ChannelsViewController: UITableViewController {
    private enum Section {
        case channels, groups
    }
    private var sections: [Section] = []
    private var channels: [Channel] = []
    private var groups: [Group] = []
    var selectedChannelIds: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "channel")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "group")

        selectedChannelIds = UserDefaults.channelIds

        channels.removeAll()
        sections = [.channels, .groups]

        let channelsRequest = Slack.ChannelsList(token: UserDefaults.accessToken)
        Api.shared.send(channelsRequest) { [weak self] (response, error) in
            if let response = response {
                self?.channels = response.channels.filter { !$0.isArchived && $0.isMember }
                self?.tableView.reloadData()
            }
            if let error = error {
                print("error: \(error)")
            }
        }

        let groupsRequest = Slack.GroupsList(token: UserDefaults.accessToken)
        Api.shared.send(groupsRequest) { [weak self] (response, error) in
            if let response = response {
                self?.groups = response.groups.filter { !$0.isArchived && !$0.isMpim }
                self?.tableView.reloadData()
            }
            if let error = error {
                print("error: \(error)")
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .channels:
            return channels.count
        case .groups:
            return groups.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .channels:
            let cell = tableView.dequeueReusableCell(withIdentifier: "channel", for: indexPath)
            let channel = channels[indexPath.row]
            cell.textLabel?.text = channel.name
            cell.accessoryType = selectedChannelIds.contains(channel.id) ? .checkmark : .none
            return cell
        case .groups:
            let cell = tableView.dequeueReusableCell(withIdentifier: "group", for: indexPath)
            let group = groups[indexPath.row]
            cell.textLabel?.text = group.name
            cell.accessoryType = selectedChannelIds.contains(group.id) ? .checkmark : .none
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath)
        switch sections[indexPath.section] {
        case .channels:
            let channel = channels[indexPath.row]
            if let index = selectedChannelIds.index(of: channel.id), index != NSNotFound {
                selectedChannelIds.remove(at: index)
                cell?.accessoryType = .none
            } else {
                selectedChannelIds.append(channel.id)
                cell?.accessoryType = .checkmark
            }
        case .groups:
            let group = groups[indexPath.row]
            if let index = selectedChannelIds.index(of: group.id), index != NSNotFound {
                selectedChannelIds.remove(at: index)
                cell?.accessoryType = .none
            } else {
                selectedChannelIds.append(group.id)
                cell?.accessoryType = .checkmark
            }
        }
        UserDefaults.channelIds = selectedChannelIds
    }
}
